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
  version = "0.17.0";

  src = fetchsrc version {
    x86_64-linux = "sha256-kYS8o97HBjNgwmrG4fjsqFWxZy6ATFOhxt6j3KMZbEc=";
    aarch64-linux = "sha256-/Tpna2Y8+PQt+SeOJ9NDweRWGiQXU/sN+Wh/vLYQPwM=";
    x86_64-darwin = "sha256-aOUmnD+l/Cc5qTiHxFLBjCatszmPdUc4YYZ6Oy5DT3U=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D octant $out/bin/octant
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/octant --help
    $out/bin/octant version | grep "${version}"
    runHook postInstallCheck
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
