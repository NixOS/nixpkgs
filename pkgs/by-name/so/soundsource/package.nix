{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "6.1.1";

  src = fetchzip {
    url = "https://web.archive.org/web/20260815122132/https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip";
    hash = "sha256-yzZF/MAkj9hFYVsde5br51Of5y0ZE90ryc881BGTyz8=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/SoundSource.app"
    cp -R $src/. "$out/Applications/SoundSource.app/"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://rogueamoeba.com/support/releasenotes/?product=SoundSource";
    description = "Sound controller for macOS";
    homepage = "https://rogueamoeba.com/soundsource";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      emilytrau
      _4evy
      dfjay
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
