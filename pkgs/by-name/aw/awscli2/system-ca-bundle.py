
# appended to awscli/botocore/httpsession.py by nixpkgs
_nix_upstream_where = where


def where():
    for path in (
        os.environ.get("NIX_SSL_CERT_FILE"),
        os.environ.get("SSL_CERT_FILE"),
        "/etc/ssl/certs/ca-certificates.crt",
        "/etc/ssl/cert.pem",
    ):
        if path and os.path.isfile(path):
            return path
    return _nix_upstream_where()
