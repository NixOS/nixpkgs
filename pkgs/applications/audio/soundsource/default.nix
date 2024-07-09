{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "5.6.3";

  src = fetchurl {
    url = "https://web.archive.org/web/20240505002011/https://rogueamoeba.com/soundsource/download/SoundSource.zip";
    sha256 = "sha256-uXQw4MEV4hkrd7tjNCxtuXpbfmdW8bilI5ZmXwn9BLM=";
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
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.darwin;
  };
})
