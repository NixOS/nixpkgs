{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "linear";
  version = "1.32.8";

  src = fetchurl {
    url = "https://releases.linear.app/Linear-${finalAttrs.version}-universal.dmg";
    hash = "sha256-CNQrkXvEQGgjHUep4Urp/awsqV+mtFHoEPzaD3Vu1KM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = "Linear";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Linear.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "App to manage software development and track bugs";
    homepage = "https://linear.app/";
    license = lib.licenses.unfree;
    mainDarwinApp = "Linear.app";
    maintainers = with lib.maintainers; [
      wini
      pradyuman
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
