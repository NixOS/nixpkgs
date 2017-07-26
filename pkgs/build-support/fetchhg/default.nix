{stdenv, mercurial, nix}: {name ? null, url, rev ? null, md5 ? null, sha256 ? null, fetchSubrepos ? false}:

if md5 != null then
  throw "fetchhg does not support md5 anymore, please use sha256"
else
# TODO: statically check if mercurial as the https support if the url starts woth https.
stdenv.mkDerivation {
  name = "hg-archive" + (if name != null then "-${name}" else "");
  builder = ./builder.sh;
  buildInputs = [mercurial];

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;

  subrepoClause = if fetchSubrepos then "S" else "";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev;
  preferLocalBuild = true;
}
