# Fetches a chicken egg from henrietta using `chicken-install -r'
# See: http://wiki.call-cc.org/chicken-projects/egg-index-4.html

{ stdenv, chicken }:
{ name, version, md5 ? "", sha256 ? "" }:

if md5 != "" then
  throw "fetchegg does not support md5 anymore, please use sha256"
else
stdenv.mkDerivation {
  name = "chicken-${name}-export";
  builder = ./builder.sh;
  buildInputs = [ chicken ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit version;

  eggName = name;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
}

