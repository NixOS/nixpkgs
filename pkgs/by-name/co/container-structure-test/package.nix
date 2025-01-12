{
  lib,
  stdenv,
  fetchurl,
}:
let
  version = "v1.19.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-linux-amd64";
      hash = "sha256-7KScpej6Km4fuv6XJez4frLwXUm91lII2RLLT71YRrs=";
    };
    aarch64-linux = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-linux-arm64";
      hash = "sha256-5MyjOzbDPrV5R3ldJCINipJPOILCzx8+xBVO4bxq9ic=";
    };
    x86_64-darwin = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-darwin-amd64";
      hash = "sha256-2QwyKvgzOdGOEuZVwntCpBGBk0JnOLpYOoEYp48qB/I=";
    };
    aarch64-darwin = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-darwin-arm64";
      hash = "sha256-x3RmVdDFmHoGOqX49OWeAab/6m1U0jq/g/30rNjj5aI=";
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
