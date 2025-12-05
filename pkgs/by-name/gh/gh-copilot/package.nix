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
      hash = "sha256-WVb32g9eqoeQgvPUGOQ7r3oD+PerKYQWEh/PoZwVqkI=";
    };
    "aarch64-linux" = {
      name = "linux-arm64";
      hash = "sha256-nZg7u0BUIHOdu3dg28fydgm6ctr4jOOIZOA5ms3/E64=";
    };
    "x86_64-darwin" = {
      name = "darwin-amd64";
      hash = "sha256-A+FQ7AgjqS1/7LExhyKwXlCAwCveSgeyhbCNAjqQ770=";
    };
    "aarch64-darwin" = {
      name = "darwin-arm64";
      hash = "sha256-+Q1H9h1j1kusEu1HW3zHWQ8ReR50kwjj4kGC3g6Jzqc=";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gh-copilot";
  version = "1.2.0";

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
