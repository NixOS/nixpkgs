{
  lib,
  stdenv,
  fetchurl,
}:
let
  version = "v1.19.3";

  sources = {
    x86_64-linux = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-linux-amd64";
      hash = "sha256-+g+jM7trpcFAZedGjSkE9cgtAh1+HHY8mkXF8vvp/18=";
    };
    aarch64-linux = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-linux-arm64";
      hash = "sha256-h00EGDxBgq2pkTwfNObRcrhsIbzRh5dSgQe0n5ttvDE=";
    };
    x86_64-darwin = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-darwin-amd64";
      hash = "sha256-gnhSbbfgqE1pjpszHUvwh7DZasDtPlVX3bxl+nJz/6Q=";
    };
    aarch64-darwin = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-darwin-arm64";
      hash = "sha256-IxCYdoIXw1lGZ8Uh6ZFXS/1DcLOz3pWSCNVAWWV/2VY=";
    };
  };
in
stdenv.mkDerivation {
  inherit version;
  pname = "container-structure-test";
  src = fetchurl { inherit (sources.${stdenv.system}) url hash; };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/container-structure-test
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/GoogleContainerTools/container-structure-test";
    description = "The Container Structure Tests provide a powerful framework to validate the structure of a container image.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rubenhoenle ];
    platforms = builtins.attrNames sources;
    mainProgram = "container-structure-test";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
