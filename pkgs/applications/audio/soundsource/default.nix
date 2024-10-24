{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundsource";
  version = "5.7.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20240924103013/https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip";
    sha256 = "sha256-02+Jb+3GSirypBISjdFg89Dp3LtkgPKho8OCVS+GGcQ=";
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
