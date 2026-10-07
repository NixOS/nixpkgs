{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

let
  source = import ./source.nix;
in
stdenvNoCC.mkDerivation {
  pname = "chatgpt";
  inherit (source) version;

  src = fetchurl source.src;

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
