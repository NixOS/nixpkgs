{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "5.7.3";

  src = fetchurl {
    url = "https://web.archive.org/web/20241112212337/https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip";
    sha256 = "sha256-Eup7oiq8vVn2MqxJxE/Z2LtDMdluczHusRJ9uoW3X84=";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sound controller for macOS";
    homepage = "https://rogueamoeba.com/soundsource";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      emilytrau
      donteatoreo
    ];
    platforms = platforms.darwin;
  };
})
