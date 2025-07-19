{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  writeShellApplication,
  cacert,
  curl,
  common-updater-scripts,
  xmlstarlet,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dia-browser";
  version = "0.38.0-65530";

  src = fetchurl {
    url = "https://releases.diabrowser.com/release/Dia-${finalAttrs.version}.zip";
    hash = "sha256-+WthIiVUYpsEueE25zDc6BwHRcftSl8LkxzyAkx0TLM=";
  };

  # Preserve Notarization
  dontFixup = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "Dia.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Dia.app"
    cp -R . "$out/Applications/Dia.app"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "dia-browser-update-script";
    runtimeInputs = [
      cacert
      curl
      common-updater-scripts
      xmlstarlet
    ];
    text = ''
      xml_content=$(curl -s "https://releases.diabrowser.com/BoostBrowser-updates.xml")
      latest_build=$(echo "$xml_content" | xmlstarlet sel -N sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" -t -v "//item[1]/sparkle:version" 2>/dev/null || echo "")
      short_version=$(echo "$xml_content" | xmlstarlet sel -N sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" -t -v "//item[1]/sparkle:shortVersionString" 2>/dev/null || echo "")
      # Parse version from shortVersionString (format: "0.35.2 (64884)")
      version_info=$(echo "$short_version" | sed -n 's/^\([0-9]*\.[0-9]*\.[0-9]*\) .*/\1/p' || echo "")

      if [[ -z "$latest_build" || -z "$version_info" ]]; then
        echo "Failed to extract version information from XML feed"
        echo "Build: '$latest_build', Version: '$version_info'"
        echo "Short version string: '$short_version'"
        exit 1
      fi
      new_version="$version_info-$latest_build"

      update-source-version dia-browser "$new_version"
    '';
  });

  meta = {
    description = "Dia the AI browser from The Browser Company";
    homepage = "https://www.diabrowser.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
