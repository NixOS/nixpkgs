{
  stdenv,
  lib,
  fossil,
  cacert,
}:

lib.fetchers.withNormalizedHash { } (
  {
    name ? null,
    url,
    rev,
    outputHash ? lib.fakeHash,
    outputHashAlgo ? null,
  }:

  stdenv.mkDerivation {
    name = "fossil-archive" + (lib.optionalString (name != null) "-${name}");
    builder = ./builder.sh;
    nativeBuildInputs = [
      fossil
      cacert
    ];

    # Envvar docs are hard to find. A link for the future:
    # https://www.fossil-scm.org/index.html/doc/trunk/www/env-opts.md
    impureEnvVars = [ "http_proxy" ];

    inherit outputHash outputHashAlgo;
    outputHashMode = "recursive";

    inherit url rev;
    preferLocalBuild = true;
  }
)
