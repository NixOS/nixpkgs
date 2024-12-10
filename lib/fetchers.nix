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
    "HTTP_PROXY"
    "HTTPS_PROXY"
    "FTP_PROXY"
    "ALL_PROXY"
    "NO_PROXY"
  ];

}
