{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "6.0.2";

  src = fetchurl {
    url = "https://web.archive.org/web/20251220113913/https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip";
    hash = "sha256-tzgGUYaY6mIZXs3xxGC3b3AoJ/DcaESYr49zcDS7+Fo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    unzip -d "$out/Applications" $src

    runHook postInstall
  '';

  meta = {
    changelog = "https://rogueamoeba.com/support/releasenotes/?product=SoundSource";
    description = "Sound controller for macOS";
    homepage = "https://rogueamoeba.com/soundsource";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      emilytrau
      FlameFlag
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
