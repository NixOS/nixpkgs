# You can specify some extra mirrors and a cache DB via options
{stdenv, monotone, defaultDBMirrors ? [], cacheDB ? ""}:
# dbs is a list of strings
# each is an url for sync

# selector is mtn selector, like h:org.example.branch
# 
{name ? "", dbs ? [], selector ? "", branch, md5 ? "", sha1 ? "", sha256 ? ""}:

stdenv.mkDerivation {
  name = if name != "" then name else "mtn-checkout";
  builder = ./builder.sh;
  buildInputs = [monotone];

  outputHashAlgo = if sha256 == "" then (if sha1 == "" then "md5" else "sha1") else "sha256";
  outputHashMode = "recursive";
  outputHash = if sha256 == "" then (if sha1 == "" then md5 else sha1) else sha256;

  dbs = defaultDBMirrors ++ dbs;
  cacheDB = if cacheDB != "" then cacheDB else "./mtn-checkout.db";
  selector = if selector != "" then selector else "h:" + branch;
  inherit branch;

  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
    ];
}

