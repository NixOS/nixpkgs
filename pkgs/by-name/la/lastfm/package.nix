{ lib
, fetchzip
, stdenvNoCC
, writeShellApplication
, curl
, xmlstarlet
, common-updater-scripts
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lastfm";
  version = "2.1.39";

  src = fetchzip {
    extension = "zip";
    name = "Last.fm.app";
    url = "https://cdn.last.fm/client/Mac/Last.fm-${finalAttrs.version}.zip";
    hash = "sha256-jxFh0HbY4g5xcvAI20b92dL1FRvRqPwBBa0Cv9k63+s=";
  };

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "lastfm-update-script";
    runtimeInputs = [
      curl
      xmlstarlet
      common-updater-scripts
    ];
    text = ''
      url=$(curl --silent "https://cdn.last.fm/client/Mac/updates.xml")
      version=$(echo "$url" | xmlstarlet sel -t -v "substring-before(substring-after(//enclosure/@url, 'version='), '&')")
      update-source-version lastfm "$version"
    '';
  });

  meta = {
    description = "Music services manager";
    homepage = "https://www.last.fm/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iivusly ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
