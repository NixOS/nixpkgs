{
  stdenv,
  lib,
  fetchurl,
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  systemToPlatform = {
    "x86_64-linux" = {
      name = "linux-amd64";
      hash = "sha256-QKrDFCVCWYYX2jM8le2X/OLhNcwxR+liUtXHhW7jcSw=";
    };
    "aarch64-linux" = {
      name = "linux-arm64";
      hash = "sha256-+l1hBwep/YMP7EOrEIn2xCIiVgWB0JCWz+fj2ZfivNQ=";
    };
    "x86_64-darwin" = {
      name = "darwin-amd64";
      hash = "sha256-YFQh4vDtT+mjAIMt0IEtleOFTlxkHMbJq/SrI+IzNjc=";
    };
    "aarch64-darwin" = {
      name = "darwin-arm64";
      hash = "sha256-qVsItCI3LxPraOLtEvVaoTzhoGEcIySTWooMBSMLvAc=";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gh-copilot";
  version = "1.0.5";

  src = fetchurl {
    name = "gh-copilot";
    url = "https://github.com/github/gh-copilot/releases/download/v${finalAttrs.version}/${platform.name}";
    hash = platform.hash;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -m755 -D $src $out/bin/gh-copilot

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/github/gh-copilot/releases/tag/v${finalAttrs.version}";
    description = "Ask for assistance right in your terminal";
    homepage = "https://github.com/github/gh-copilot";
    license = lib.licenses.unfree;
    mainProgram = "gh-copilot";
    maintainers = with lib.maintainers; [ perchun ];
    platforms = lib.attrNames systemToPlatform;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
