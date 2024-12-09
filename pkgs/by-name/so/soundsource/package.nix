{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "5.7.4";

  src = fetchurl {
    url = "https://web.archive.org/web/20241204215222/https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip";
    hash = "sha256-zDIlhwczwXVPOV90EKF9pjO2CKlOEeFsqx17nIXaElw=";
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
      donteatoreo
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
