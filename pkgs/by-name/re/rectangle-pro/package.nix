{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rectangle-pro";
  version = "3.0.9";

  src = fetchurl {
    url = "https://rectangleapp.com/pro/downloads/Rectangle%20Pro%20${finalAttrs.version}.dmg";
    hash = "sha256-wD8yi2Pbgrn1fW/xrocepDcpzSMsQH5yjB/Jv90PuGQ=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Move and resize windows in macOS using keyboard shortcuts or snap areas";
    homepage = "https://rectangleapp.com/pro";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
