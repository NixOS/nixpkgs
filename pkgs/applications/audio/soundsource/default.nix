{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "5.6.0";

  src = fetchurl {
    url = "https://web.archive.org/web/20230707140658/https://rogueamoeba.com/soundsource/download/SoundSource.zip";
    sha256 = "1avm1jr75mjbps0fad3glshrwl42vnhc0f9sak038ny85f3apyi0";
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
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
