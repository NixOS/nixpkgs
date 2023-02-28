{ lib, stdenvNoCC, mercurial }:
{ name ? null
, url
, rev ? null
, md5 ? null
, sha256 ? null
, fetchSubrepos ? false
, preferLocalBuild ? true }:

if md5 != null then
  throw "fetchhg does not support md5 anymore, please use sha256"
else
# TODO: statically check if mercurial as the https support if the url starts woth https.
stdenvNoCC.mkDerivation {
  name = "hg-archive" + (lib.optionalString (name != null) "-${name}");
  builder = ./builder.sh;
  nativeBuildInputs = [mercurial];

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;

  subrepoClause = lib.optionalString fetchSubrepos "S";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev;
  inherit preferLocalBuild;
}
