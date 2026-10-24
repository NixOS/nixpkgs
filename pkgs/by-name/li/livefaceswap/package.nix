{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "livefaceswap";
  version = "0.2.7";

  src = fetchurl {
    url = "https://github.com/LiveFaceSwapAI/livefaceswap/releases/download/v${finalAttrs.version}/LiveFaceSwap-${finalAttrs.version}-nixpkgs-arm64.dmg";
    hash = "sha256-eiKOGJAkLjNJaO1AURszHhbdB89N8BXUdD17KD9HucU=";
  };

  nativeBuildInputs = [ undmg ];

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "LiveFaceSwap.app";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/LiveFaceSwap.app" "$out/bin"
    cp -R . "$out/Applications/LiveFaceSwap.app"
    ln -s "$out/Applications/LiveFaceSwap.app/Contents/MacOS/LiveFaceSwap" "$out/bin/livefaceswap"

    runHook postInstall
  '';

  meta = {
    description = "Realtime AI face swap virtual camera for macOS";
    homepage = "https://livefaceswap.ai/";
    changelog = "https://github.com/LiveFaceSwapAI/livefaceswap/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    mainProgram = "livefaceswap";
    maintainers = with lib.maintainers; [ cabbagehao ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
