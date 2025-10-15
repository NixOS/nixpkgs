{ lib, stdenvNoCC, fetchurl }:

let
  version = "3.0.0";

  urls = {
    "x86_64-linux" = {
      plain = "https://github.com/lambdaclass/ethrex/releases/download/v${version}/ethrex-linux_x86_64";
    };
    "aarch64-linux" = {
      plain = "https://github.com/lambdaclass/ethrex/releases/download/v${version}/ethrex-linux_aarch64";
    };
    "aarch64-darwin" = {
      plain = "https://github.com/lambdaclass/ethrex/releases/download/v${version}/ethrex-macos_aarch64";
    };
  };

  hashes = {
    "x86_64-linux".plain   = "sha256-Vg6jwBj5jrSAsb7nn04G/HEKhQyX8sICjmmPMpkIHTI=";
    "aarch64-linux".plain  = "sha256-8ML5R6EvvYbnfxCRG5mqgNqY/vkl1iEOdoEHKF4BaX8=";
    "aarch64-darwin".plain = "sha256-dMoRtiJOCLV2B4coLrSLkYdEkTKsvbJGzmv049UpBhY=";
  };

  sys = stdenvNoCC.hostPlatform.system;

  _ = if !(lib.hasAttr sys urls) then
        throw "ethrex-bin ${version}: platform ${sys} not supported (supported: ${builtins.concatStringsSep ", " (builtins.attrNames urls)})"
      else null;

  srcUrl  = urls.${sys}.plain;
  srcHash = hashes.${sys}.plain;

in
stdenvNoCC.mkDerivation rec {
  pname = "ethrex-bin";
  inherit version;

  src = fetchurl { url = srcUrl; sha256 = srcHash; };
  dontUnpack = true;

  installPhase = ''
    install -Dm755 "$src" "$out/bin/ethrex"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    "$out/bin/ethrex" --version >/dev/null
  '';

  meta = with lib; {
    description = "A lightweight, performant, and modular Ethereum execution client powering next-gen L1 and L2 solutions.";
    homepage = "https://ethrex.xyz/";
    license = licenses.asl20;
    mainProgram = "ethrex";
    platforms = builtins.attrNames urls;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    changelog = "https://github.com/lambdaclass/ethrex/releases/tag/v${version}";
    maintainers = with maintainers; [ samoht9277 klaus993 ];
  };
}
