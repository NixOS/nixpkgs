mitmCacheConfigureHook() {
    if [ -d "$mitmCache" ] && [ -z "$MITM_CACHE_CERT_DIR" ]; then
        MITM_CACHE_CERT_DIR="$(mktemp -d)"
        pushd "$MITM_CACHE_CERT_DIR"
        MITM_CACHE_CA="$MITM_CACHE_CERT_DIR/ca.cer"
        @openssl@/bin/openssl genrsa -out ca.key 2048
        @openssl@/bin/openssl req -x509 -new -nodes -key ca.key -sha256 -days 1 -out ca.cer -subj "/C=AL/ST=a/L=a/O=a/OU=a/CN=example.org"
        MITM_CACHE_HOST="127.0.0.1"
        MITM_CACHE_PORT="${mitmCachePort:-$(@ephemeral_port_reserve@/bin/ephemeral-port-reserve "$MITM_CACHE_HOST")}"
        MITM_CACHE_ADDRESS="$MITM_CACHE_HOST:$MITM_CACHE_PORT"
        export http_proxy="$MITM_CACHE_ADDRESS"
        export https_proxy="$MITM_CACHE_ADDRESS"
        export SSL_CERT_FILE="$MITM_CACHE_CA"
        export NIX_SSL_CERT_FILE="$MITM_CACHE_CA"
        mitm-cache -l"$MITM_CACHE_ADDRESS" replay "$mitmCache" >/dev/null 2>/dev/null &
        popd
    fi
}

# prepend it so any other configure hooks can use the generated root CA
preConfigureHooks=(mitmCacheConfigureHook "${preConfigureHooks[@]}")
