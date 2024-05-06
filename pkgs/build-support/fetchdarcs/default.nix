{stdenvNoCC, darcs, cacert, lib}:

lib.makeOverridable (
  lib.fetchers.withNormalizedHash { } (
    { url
    , rev ? null
    , context ? null
    , outputHash ? lib.fakeHash
    , outputHashAlgo ? null
    , name ? "fetchdarcs"
    }:

    stdenvNoCC.mkDerivation {
      builder = ./builder.sh;
      nativeBuildInputs = [cacert darcs];

      inherit outputHash outputHashAlgo;
      outputHashMode = "recursive";

      inherit url rev context name;
    }
  )
)
