{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "itsycal";
  version = "0.15.7";

  src = fetchzip {
    url = "https://itsycal.s3.amazonaws.com/Itsycal-${finalAttrs.version}.zip";
    hash = "sha256-0JQ7fZ0cZM8DnAODZQKzUQEHQGhkNvV+0NY10Ef7MEw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Itsycal.app"
    cp -R . "$out/Applications/Itsycal.app"

    runHook postInstall
  '';

  meta = {
    changelog = "https://www.mowglii.com/itsycal/versionhistory.html";
    description = "Tiny menu bar calendar";
    homepage = "https://www.mowglii.com/itsycal/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      FlameFlag
      iedame
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
