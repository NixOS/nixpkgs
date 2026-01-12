export NIX_SSL_CERT_FILE="${NIX_SSL_CERT_FILE:-@out@/etc/ssl/certs/ca-bundle.crt}"
if test ! -r "$NIX_SSL_CERT_FILE"; then
  # If we inherited an unreadable cert file path, just use the bundled one
  # TODO: This is just a workaround, the proper solution should be made on the Nix side
  #       Issue: https://github.com/NixOS/nix/issues/12698
  export NIX_SSL_CERT_FILE="@out@/etc/ssl/certs/ca-bundle.crt"
fi

# compatibility
#  - openssl
export SSL_CERT_FILE=$NIX_SSL_CERT_FILE
#  - Haskell x509-system
export SYSTEM_CERTIFICATE_PATH=$NIX_SSL_CERT_FILE
