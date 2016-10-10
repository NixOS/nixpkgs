# Fetches a chicken egg from henrietta using `chicken-install -r'
# See: http://wiki.call-cc.org/chicken-projects/egg-index-4.html

{ stdenv, chicken }:
{ name, version, md5 ? "", sha256 ? "" }:

stdenv.mkDerivation {
  name = "chicken-${name}-export";
  builder = ./builder.sh;
  buildInputs = [ chicken ];

  outputHashAlgo = if sha256 == "" then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if sha256 == "" then
    (stdenv.lib.fetchMD5warn "fetchegg" name md5) else sha256;

  inherit version;

  eggName = name;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
}

