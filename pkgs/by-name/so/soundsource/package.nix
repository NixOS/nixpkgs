{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "6.1.6";

  src = fetchzip {
    url = "https://web.archive.org/web/20261027065104/https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip";
    hash = "sha256-AxnJ27tkXXJIShpu0iRREo8EyWwCqZyhIYhl+L3DbuI=";
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
