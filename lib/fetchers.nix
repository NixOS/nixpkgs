# snippets that can be shared by multiple fetchers (pkgs/build-support)
{ lib }:
{

  proxyImpureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy"
    "https_proxy"
    "ftp_proxy"
    "all_proxy"
    "no_proxy"

    # https proxies typically need to inject custom root CAs too
    "NIX_SSL_CERT_FILE"
  ];

}
