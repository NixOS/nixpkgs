{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "octant";
  version = "0.19.0";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      suffix = {
        x86_64-linux = "Linux-64bit";
        aarch64-linux = "Linux-arm64";
        x86_64-darwin = "macOS-64bit";
      }.${system} or (throw "Unsupported system: ${system}");
      fetchsrc = version: sha256: fetchzip {
        url = "https://github.com/vmware-tanzu/octant/releases/download/v${version}/octant_${version}_${suffix}.tar.gz";
        sha256 = sha256.${system};
      };
    in
    fetchsrc version {
      x86_64-linux = "sha256-TKvUBof4TLcHr9hg6AOLjVd1NcAX9HHVuuABdFKRNQA=";
      aarch64-linux = "sha256-BJb7h6kJZ3QhdlEqNHkiFp91uYLXzYHvKftxEAhjY38=";
      x86_64-darwin = "sha256-Ig98IqLmlN9D4iXrP9SXYwTrQOvbtQ/tQW+uEmntm+I=";
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
    description = "Highly extensible platform for developers to better understand the complexity of Kubernetes clusters";
    longDescription = ''
      Octant is a tool for developers to understand how applications run on a
      Kubernetes cluster.
      It aims to be part of the developer's toolkit for gaining insight and
      approaching complexity found in Kubernetes. Octant offers a combination of
      introspective tooling, cluster navigation, and object management along
      with a plugin system to further extend its capabilities.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
