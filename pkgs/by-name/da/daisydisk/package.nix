{
  lib,
  stdenvNoCC,
  fetchzip,
  curl,
  cacert,
  xmlstarlet,
  common-updater-scripts,
  writeShellApplication,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "daisydisk";
  version = "4.32";

  src = fetchzip {
    url = "https://daisydiskapp.com/download/DaisyDisk.zip";
    hash = "sha256-HRW851l3zCq43WmLkElvVlIEmfCsCUMFw/LL2cPa2Xk=";
    stripRoot = false;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv DaisyDisk.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "daisydisk-update-script";
    runtimeInputs = [
      curl
      cacert
      xmlstarlet
      common-updater-scripts
    ];
    text = ''
      url="https://daisydiskapp.com/downloads/appcastFeed.php"
      version=$(curl -s "$url" |  xmlstarlet sel -t -v 'rss/channel/item[1]/enclosure/@sparkle:version' -n)
      update-source-version daisydisk "$version"
    '';
  });

  meta = {
    description = "Find out what’s taking up your disk space and recover it in the most efficient and easy way";
    homepage = "https://daisydiskapp.com/";
    changelog = "https://daisydiskapp.com/releases";
    license = [ lib.licenses.unfree ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.darwin;
  };
})
