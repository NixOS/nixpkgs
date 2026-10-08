{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "chatgpt";
  version = "26.930.41038";

  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/ChatGPT-darwin-arm64-26.930.41038.zip";
    hash = "sha256-9s9NLptpru+jOt2kvNGi0wY1f1JToaxgSXAIcMKN0Mc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    unzip
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    mkdir -p "$out/bin"
    cp -a ChatGPT.app "$out/Applications"
    ln -s "$out/Applications/ChatGPT.app/Contents/MacOS/ChatGPT" "$out/bin/ChatGPT"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Desktop application for ChatGPT";
    homepage = "https://openai.com/chatgpt/desktop/";
    changelog = "https://help.openai.com/en/articles/9703738-macos-app-release-notes";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ wattmto ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "ChatGPT";
  };
}
