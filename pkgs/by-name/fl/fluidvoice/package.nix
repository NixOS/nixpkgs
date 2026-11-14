{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fluidvoice";
  version = "1.6.11";

  src = fetchurl {
    url = "https://github.com/altic-dev/FluidVoice/releases/download/v${finalAttrs.version}/Fluid-oss-${finalAttrs.version}.zip";
    hash = "sha256-/AiOhFdMHcPc0Tovs+goxBfbQ3P4h3uyZzM/sl05SdI=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  # The upstream .app is Developer-ID-signed and notarized; preserve it
  # byte-for-byte so the signature stays valid.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications $out/bin
    cp -R FluidVoice.app $out/Applications/
    ln -s $out/Applications/FluidVoice.app/Contents/MacOS/FluidVoice $out/bin/fluidvoice
    runHook postInstall
  '';

  meta = {
    description = "Open source voice-to-text dictation app for macOS with on-device AI enhancement";
    homepage = "https://github.com/altic-dev/FluidVoice";
    changelog = "https://github.com/altic-dev/FluidVoice/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.levonk ];
    mainProgram = "fluidvoice";
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
