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
      hash = "sha256-uEG9wvoUyX54rcsZI2dgSfEy9d/FMfjf4+kn5wJoojY=";
    };
    "aarch64-linux" = {
      name = "linux-arm64";
      hash = "sha256-r0Vo9lZygIEQeSqPv1ix/NK347wqoCkaIL635qeP5ok=";
    };
    "x86_64-darwin" = {
      name = "darwin-amd64";
      hash = "sha256-Hu7A/M5JvwFaA5AmO1WO65D7KD3dYTGnNb0A5CqAPH0=";
    };
    "aarch64-darwin" = {
      name = "darwin-arm64";
      hash = "sha256-d6db1YOmo7If/2PTkgScsTaMqZZNZl6OL/qpgYfCa3s=";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gh-copilot";
  version = "1.0.1";

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
