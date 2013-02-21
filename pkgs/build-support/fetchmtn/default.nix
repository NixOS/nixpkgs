# You can specify some extra mirrors and a cache DB via options
{stdenv, monotone, defaultDBMirrors ? [], cacheDB ? "./mtn-checkout.db"}:
# dbs is a list of strings
# each is an url for sync

# selector is mtn selector, like h:org.example.branch
# 
{name ? "mtn-checkout", dbs ? [], sha256
, selector ? "h:" + branch, branch}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  nativeBuildInputs = [monotone];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  dbs = defaultDBMirrors ++ dbs;
  inherit branch cacheDB name selector;

  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
    ];
}

