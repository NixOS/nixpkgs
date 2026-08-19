{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  unzip,
}:

let
  source = import ./source.nix;
in
stdenvNoCC.mkDerivation {
  pname = "chatgpt-classic";
  inherit (source) version;

  src = fetchurl source.src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    xar
    cpio
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf "$src"
    zcat Payload | cpio -i
    unzip -q "Library/Application Support/OpenAI/ChatGPT Classic Update/ChatGPT Classic.app.zip"

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    mkdir -p "$out/bin"
    cp -a "ChatGPT Classic.app" "$out/Applications"
    ln -s "$out/Applications/ChatGPT Classic.app/Contents/MacOS/ChatGPT Classic" "$out/bin/ChatGPT Classic"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Desktop application for ChatGPT Classic";
    homepage = "https://openai.com/chatgpt/desktop/";
    changelog = "https://help.openai.com/en/articles/9703738-macos-app-release-notes";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ wattmto ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "ChatGPT Classic";
  };
}
