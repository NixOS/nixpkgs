{ lib, stdenvNoCC, mercurial }:
{ name ? null
, url
, rev ? null
, sha256 ? null
, hash ? null
, fetchSubrepos ? false
, preferLocalBuild ? true }:

if hash != null && sha256 != null then
  throw "Only one of sha256 or hash can be set"
else
# TODO: statically check if mercurial as the https support if the url starts woth https.
stdenvNoCC.mkDerivation {
  name = "hg-archive" + (lib.optionalString (name != null) "-${name}");
  builder = ./builder.sh;
  nativeBuildInputs = [mercurial];

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;

  subrepoClause = lib.optionalString fetchSubrepos "S";

  outputHashAlgo = if hash != null then null else "sha256";
  outputHashMode = "recursive";
  outputHash = if hash != null then
    hash
  else if sha256 != null then
    sha256
  else
    lib.fakeSha256;

  inherit url rev;
  inherit preferLocalBuild;
}
