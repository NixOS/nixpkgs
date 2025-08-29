{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "5.8.5";

  src = fetchurl {
    url = "https://web.archive.org/web/20250814234406/https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip";
    hash = "sha256-dsnDyQgS72MMQ9SMBar4kEE2PjFxiZYk1dJ2nIE0Y4o=";
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
