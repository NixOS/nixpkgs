{
  lib,
  stdenvNoCC,
  fetchzip,
  writeShellApplication,
  curl,
  gawk,
  xmlstarlet,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rewind-ai";
  # Example version with explanation
  # 1.5284 (Base version)
  # 15284.1 (build number)
  # dcd0176 (commit hash)
  # 20240504 (pub date)
  version = "1.5284-15284.1-dcd0176-20240504";

  src = fetchzip {
    url =
      let
        buildNumber = lib.elemAt (lib.splitString "-" finalAttrs.version) 1;
        commitHash = lib.elemAt (lib.splitString "-" finalAttrs.version) 2;
      in
      "https://updates.rewind.ai/builds/main/b${buildNumber}-main-${commitHash}.zip";
    hash = "sha256-Y7iAYHH/msZoXFzAZHJb6YoDz5fwMPHJx1kg7TqP5Gw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Rewind.app"
    cp -R . "$out/Applications/Rewind.app"

    runHook postInstall
  '';

  # Example response to use when modifing the script: https://pastebin.com/raw/90qU3n6H
  # There is a real harsh limit on update checks, so DO NOT send any unnecessary update checks
  # Wait at least 3 days since the last pub_date (you will find the date at the end of the version number)
  # Example: 20240504 would be 2024/05/04, and that would mean that we want to check no earlier than on 2024/05/07 for any updates
  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "${finalAttrs.pname}-update-script";
    runtimeInputs = [
      curl
      gawk
      xmlstarlet
      common-updater-scripts
    ];
    text = ''
      xml_get () {
        echo "$update_xml" | xmlstarlet sel -t -v "$1"
      }

      update_url="https://updates.rewind.ai/appcasts/main.xml"

      update_xml=$(curl -s "$update_url")

      version_base=$(xml_get "/rss/channel/item/sparkle:shortVersionString")
      url=$(xml_get "/rss/channel/item/enclosure/@url")
      pub_date=$(xml_get "/rss/channel/item/pubDate")
      commit_id=$(echo "$url" | awk -F '-|\\.' '{ print $(NF - 1) }')
      build_number=$(xml_get "/rss/channel/item/sparkle:version")
      formatted_pub_date=$(date -d "$pub_date" +"%Y%m%d")

      full_version="''${version_base}-''${build_number}-''${commit_id}-''${formatted_pub_date}"
      update-source-version "rewind-ai" "$full_version" --version-key=version --file=./pkgs/by-name/re/rewind-ai/package.nix --print-changes
    '';
  });

  meta = {
    changelog = "https://www.rewind.ai/changelog";
    description = "Rewind is a personalized AI powered by everything you've seen, said, or heard";
    homepage = "https://www.rewind.ai/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
