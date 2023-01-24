FROM alpine:3.17 as builder
RUN apk add --no-cache ca-certificates go
COPY go.mod go.sum /project/
RUN cd /project && go mod download
COPY ./ /project
RUN cd /project && go build

FROM alpine:3.17
RUN apk add --no-cache ca-certificates
COPY --from=builder /project/oidc-test-client /project/oidc-test-client
EXPOSE 9009
WORKDIR /web-root
ENV OIDC_BIND=0.0.0.0:9009
HEALTHCHECK CMD [ "wget", "--spider", "http://localhost:9009/health" ]
ENTRYPOINT [ "/project/oidc-test-client" ]
