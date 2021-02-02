{ lib, stdenv, fetchzip }:

let
  inherit (stdenv.hostPlatform) system;
  suffix = {
    x86_64-linux = "Linux-64bit";
    aarch64-linux = "Linux-arm64";
    x86_64-darwin = "macOS-64bit";
  }."${system}" or (throw "Unsupported system: ${system}");
  baseurl = "https://github.com/vmware-tanzu/octant/releases/download";
  fetchsrc = version: sha256: fetchzip {
      url = "${baseurl}/v${version}/octant_${version}_${suffix}.tar.gz";
      sha256 = sha256."${system}";
    };
in
stdenv.mkDerivation rec {
  pname = "octant";
  version = "0.16.3";

  src = fetchsrc version {
    x86_64-linux = "sha256-YqwQOfE1Banq9s80grZjALC7Td/P1Y0gMVGG1FXE7vY=";
    aarch64-linux = "sha256-eMwBgAtjAuxeiLhWzKB8TMMM6xjFI/BL6Rjnd/ksMBs=";
    x86_64-darwin = "sha256-f7ks77jPGzPPIguleEg9aF2GG+w0ihIgyoiCdZiGeIw=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D octant $out/bin/octant
    runHook postInstall
  '';

  dontPatchELF = true;
  dontPatchShebangs = true;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://octant.dev/";
    changelog = "https://github.com/vmware-tanzu/octant/blob/v${version}/CHANGELOG.md";
    description = "Highly extensible platform for developers to better understand the complexity of Kubernetes clusters.";
    longDescription = ''
      Octant is a tool for developers to understand how applications run on a Kubernetes cluster.
      It aims to be part of the developer's toolkit for gaining insight and approaching complexity found in Kubernetes.
      Octant offers a combination of introspective tooling, cluster navigation, and object management along with a
      plugin system to further extend its capabilities.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
