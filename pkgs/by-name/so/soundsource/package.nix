{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "6.1.0";

  src = fetchzip {
    url = "https://web.archive.org/web/20260724150017/https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip";
    hash = "sha256-C7VvtREU7NA27N9VRQ+ktU6iTQL5wWGEND+3oG6jyII=";
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
