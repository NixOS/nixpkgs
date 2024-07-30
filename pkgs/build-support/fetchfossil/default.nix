{stdenv, lib, fossil, cacert}:

{ name ? null
, url
, rev
, sha256 ? ""
, hash ? ""
}:

if hash != "" && sha256 != "" then
  throw "Only one of sha256 or hash can be set"
else
stdenv.mkDerivation {
  name = "fossil-archive" + (lib.optionalString (name != null) "-${name}");
  builder = ./builder.sh;
  nativeBuildInputs = [fossil cacert];

  # Envvar docs are hard to find. A link for the future:
  # https://www.fossil-scm.org/index.html/doc/trunk/www/env-opts.md
  impureEnvVars = [ "http_proxy" ];

  outputHashAlgo = if hash != "" then null else "sha256";
  outputHashMode = "recursive";
  outputHash = if hash != "" then
    hash
  else if sha256 != "" then
    sha256
  else
    lib.fakeSha256;

  inherit url rev;
  preferLocalBuild = true;
}
