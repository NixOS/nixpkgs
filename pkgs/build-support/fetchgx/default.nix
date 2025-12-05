{
  lib,
  stdenvNoCC,
  gx,
  gx-go,
  go,
  cacert,
}:

lib.fetchers.withNormalizedHash { } (
  {
    name,
    src,
    outputHash,
    outputHashAlgo,
  }:

  stdenvNoCC.mkDerivation {
    name = "${name}-gxdeps";
    inherit src;

    nativeBuildInputs = [
      cacert
      go
      gx
      gx-go
    ];

    inherit outputHash outputHashAlgo;
    outputHashMode = "recursive";

    dontConfigure = true;
    doCheck = false;
    doInstallCheck = false;

    buildPhase = ''
      export GOPATH=$(pwd)/vendor
      mkdir -p vendor
      gx install
    '';

    installPhase = ''
      mv vendor $out
    '';

  }
)
