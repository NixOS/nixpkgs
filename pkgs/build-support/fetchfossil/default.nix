{stdenv, lib, fossil, cacert}:

{name ? null, url, rev, sha256}:

stdenv.mkDerivation {
  name = "fossil-archive" + (lib.optionalString (name != null) "-${name}");
  builder = ./builder.sh;
  nativeBuildInputs = [fossil cacert];

  # Envvar docs are hard to find. A link for the future:
  # https://www.fossil-scm.org/index.html/doc/trunk/www/env-opts.md
  impureEnvVars = [ "http_proxy" ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev;
  preferLocalBuild = true;
}
