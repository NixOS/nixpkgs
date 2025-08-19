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
      hash = "sha256-bDAhFU18dliKlKY5WQVsVSMVyF4YeTaKO9pwheMcdcg=";
    };
    "aarch64-linux" = {
      name = "linux-arm64";
      hash = "sha256-uddWn2RxQyB9s7kx6FI/oH9L/7l/fMD/7HQXWDqvuyQ=";
    };
    "x86_64-darwin" = {
      name = "darwin-amd64";
      hash = "sha256-L+lCmI1ciYInCt5aTcSVRDW0IwecGZ2BZNKrpeEE4jo=";
    };
    "aarch64-darwin" = {
      name = "darwin-arm64";
      hash = "sha256-9ldVRUhHM2OD+BaOCqVmaE+HFP5jj+hrfyB6wobjS+E=";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gh-copilot";
  version = "1.1.1";

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
