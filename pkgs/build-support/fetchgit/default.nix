{stdenv, git}:
{url, rev ? "HEAD", md5 ? "", sha256 ? ""}:

stdenv.mkDerivation {
  name = "git-export";
  builder = ./builder.sh;
  buildInputs = [git];

  outputHashAlgo = if sha256 == "" then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if sha256 == "" then md5 else sha256;

  inherit url rev depth;

  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
    ];
}

