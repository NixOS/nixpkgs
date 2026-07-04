{
  lib,
  stdenvNoCC,
  breezy,
}:
lib.fetchers.withNormalizedHash { } (
  {
    url,
    rev,
    outputHash,
    outputHashAlgo,
  }:

  stdenvNoCC.mkDerivation {
    name = "bzr-export";

    builder = ./builder.sh;
    nativeBuildInputs = [ breezy ];

    inherit outputHash outputHashAlgo;
    outputHashMode = "recursive";

    inherit url rev;
  }
)
