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
      hash = "sha256-HDyPQ7/suk6LA6mchwE+LHcO1+9aB7o+60lX6OKFLGQ=";
    };
    "aarch64-linux" = {
      name = "linux-arm64";
      hash = "sha256-IfAfduUMAQ53oi2ZgRxc825oMyX6PvATkQpvxmFjMHo=";
    };
    "x86_64-darwin" = {
      name = "darwin-amd64";
      hash = "sha256-I4EG6T//+YFLOlQMpW1ERpBzR/882lXMPqpO7em/QJY=";
    };
    "aarch64-darwin" = {
      name = "darwin-arm64";
      hash = "sha256-QtHCvTgfrQilIbd3S3/zkyBLccukGfFckCrZPCIMNMg=";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gh-copilot";
  version = "1.0.6";

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
