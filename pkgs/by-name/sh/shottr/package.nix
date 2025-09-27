{
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellApplication,
  cacert,
  curl,
  common-updater-scripts,
  pup,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shottr";
  version = "1.8.1";

  src = fetchurl {
    url = "https://shottr.cc/dl/Shottr-${finalAttrs.version}.dmg";
    hash = "sha256-I3LNLuhIRdjKDn79HWRK2B/tVsV+1aGt/aY442y3r2I=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Shottr.app "$out/Applications"

    mkdir -p "$out/bin"
    ln -s "$out/Applications/Shottr.app/Contents/MacOS/Shottr" "$out/bin/shottr"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "shottr-update-script";
    runtimeInputs = [
      cacert
      common-updater-scripts
      curl
      pup
    ];
    text = ''
      version="$(curl -s https://shottr.cc/newversion.html \
        | pup 'a[href*="Shottr-"] attr{href}' \
        | sed -E 's|/dl/Shottr-||' \
        | sed -E 's|\.dmg||')"
      update-source-version shottr "$version"
    '';
  });

  meta = {
    changelog = "https://shottr.cc/newversion.html";
    description = "MacOS screenshot app with scrolling screenshots, OCR, annotation and measurement instruments";
    homepage = "https://shottr.cc/";
    license = lib.licenses.unfree;
    mainProgram = "shottr";
    maintainers = with lib.maintainers; [ FlameFlag ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
