{
  lib,
  stdenvNoCC,
  gx,
  gx-go,
  go,
  cacert,

  # Used in `pkgs/build-support/prefer-remote-fetch/default.nix`
  preferLocalBuild ? true,
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
    inherit src preferLocalBuild;

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
