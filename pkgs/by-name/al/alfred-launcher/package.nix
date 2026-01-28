{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alfred-launcher";
  version = "5.1.4_2195";

  src = fetchurl {
    url = "https://cachefly.alfredapp.com/Alfred_${finalAttrs.version}.dmg";
    sha256 = "sha256-bV9OMHf+XNoPlhIMrRxQGvWZ14l/+6Jc8IUKmORKX/I=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
  dontPatchShebangs = true;

  meta = with lib; {
    description = "Application launcher and productivity software";
    homepage = "https://www.alfredapp.com";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
