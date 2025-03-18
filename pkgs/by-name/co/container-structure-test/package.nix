{
  lib,
  stdenv,
  fetchurl,
}:
let
  version = "v1.18.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-linux-amd64";
      hash = "sha256-vnZsdjRix3P7DpDz00WUTbNBLQIFPKzfUbVbxn+1ygM=";
    };
    aarch64-linux = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-linux-arm64";
      hash = "sha256-/YPAeh/Ad2YVdZ/irpgikQST0uWITWYQOB4qI54aPlY=";
    };
    x86_64-darwin = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-darwin-amd64";
      hash = "sha256-tJ1gMnQ7d6du65fnw5GV425kWl/3jLwcqj3gIHHuOyU=";
    };
    aarch64-darwin = {
      url = "https://github.com/GoogleContainerTools/container-structure-test/releases/download/${version}/container-structure-test-darwin-arm64";
      hash = "sha256-cNSb3nhSGU9q/PJDNdEeV/hlCXAdXkaV6SROdXnXjp0=";
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
