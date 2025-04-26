export NIX_SSL_CERT_FILE="${NIX_SSL_CERT_FILE:-@out@/etc/ssl/certs/ca-bundle.crt}"
if test ! -r "$NIX_SSL_CERT_FILE"; then
  # If we inherited an unreadable cert file path, just use the bundled one
  export NIX_SSL_CERT_FILE="@out@/etc/ssl/certs/ca-bundle.crt"
fi

# compatibility
#  - openssl
export SSL_CERT_FILE=$NIX_SSL_CERT_FILE
#  - Haskell x509-system
export SYSTEM_CERTIFICATE_PATH=$NIX_SSL_CERT_FILE
