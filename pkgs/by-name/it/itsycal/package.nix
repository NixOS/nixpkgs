{ lib
, fetchzip
, stdenvNoCC
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "itsycal";
  version = "0.15.3";

  src = fetchzip {
    url = "https://itsycal.s3.amazonaws.com/Itsycal-${finalAttrs.version}.zip";
    hash = "sha256-jpTlJY7yAARrkHzreQKbFaKj0sYp950R0qPPcDeY6AE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Itsycal.app
    cp -R . $out/Applications/Itsycal.app

    runHook postInstall
  '';

  meta = {
    description = "Itsycal is a tiny menu bar calendar";
    homepage = "https://www.mowglii.com/itsycal/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
