{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  curl,
  gnused,
  xmlstarlet,
  common-updater-scripts,
  writeShellScript,
}:

let
  # Mythic distributes via Sparkle; the UUID changes with each release.
  # Appcast: https://dl.getmythic.app/updates/update.xml
  uuid = "92033dfd-7a35-4629-9ca5-60d66576fb65";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mythic";
  version = "0.6.0";

  src = fetchurl {
    url = "https://dl.getmythic.app/updates/${uuid}/Mythic.zip";
    hash = "sha256-vNtUPVbnHmrj4QL/W+u73s2xBmVJIo1MXxo8XPqCyBY=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R ./Mythic.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-mythic" ''
    set -euo pipefail
    export PATH="${
      lib.makeBinPath [
        curl
        gnused
        xmlstarlet
        common-updater-scripts
      ]
    }"

    xml=$(curl -s "https://dl.getmythic.app/updates/update.xml")
    version=$(echo "$xml" | xmlstarlet sel -t -v '(//item)[1]/enclosure/@sparkle:shortVersionString')
    url=$(echo "$xml" | xmlstarlet sel -t -v '(//item)[1]/enclosure/@url')
    uuid=$(echo "$url" | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}')

    sed -i "s/uuid = \"[^\"]*\"/uuid = \"$uuid\"/" pkgs/by-name/my/mythic/package.nix
    update-source-version mythic "$version"
  '';

  meta = {
    description = "Open-source macOS game launcher";
    homepage = "https://getmythic.app/";
    changelog = "https://github.com/MythicApp/Mythic/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
