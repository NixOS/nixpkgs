{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "itsycal";
  version = "0.15.5";

  src = fetchzip {
    url = "https://itsycal.s3.amazonaws.com/Itsycal-${finalAttrs.version}.zip";
    hash = "sha256-kRO9zcyi8Di0NNuT158htKXt4wo7nVys+AV+1EgS1ZI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Itsycal.app"
    cp -R . "$out/Applications/Itsycal.app"

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://www.mowglii.com/itsycal/versionhistory.html";
    description = "Itsycal is a tiny menu bar calendar";
    homepage = "https://www.mowglii.com/itsycal/";
    license = licenses.mit;
    maintainers = with maintainers; [ donteatoreo ];
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
