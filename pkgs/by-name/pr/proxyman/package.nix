{
  lib,
  stdenv,
  callPackage,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:
let
  pname = "proxyman";

  updateScript = {
    command = writeShellScript "proxyman-update-script" ''
      set -euo pipefail

      updateArtifact() {
        local repo=$1 url=$2 file=$3 system=$4 label=$5
        local version hash
        version=$(${lib.getExe curl} --fail -s ''${GITHUB_TOKEN:+-H "Authorization: bearer $GITHUB_TOKEN"} \
          "https://api.github.com/repos/$repo/releases/latest" | ${lib.getExe jq} -r .tag_name)
        if [[ -z "$version" || "$version" == "null" ]]; then
          echo "could not determine latest release of $repo" >&2
          return 1
        fi
        if grep -q "version = \"$version\";" "$file"; then
          echo '[]'
          return
        fi
        url=''${url//@version@/$version}
        hash=$(nix store prefetch-file --json "$url" | ${lib.getExe jq} -r .hash)
        ${lib.getExe' common-updater-scripts "update-source-version"} proxyman "$version" "$hash" \
          --file="$file" --system="$system" --print-changes \
          | ${lib.getExe jq} --arg label "$label" \
              'map(.commitMessage = "proxyman: (\($label)) \(.oldVersion) -> \(.newVersion)")'
      }

      # Electron app for Linux
      linuxChanges=$(updateArtifact ProxymanApp/proxyman-windows-linux \
        "https://github.com/ProxymanApp/proxyman-windows-linux/releases/download/@version@/Proxyman-@version@.AppImage" \
        pkgs/by-name/pr/proxyman/linux.nix x86_64-linux linux)

      # Native macOS app (independent versioning)
      darwinChanges=$(updateArtifact ProxymanApp/Proxyman \
        "https://github.com/ProxymanApp/Proxyman/releases/download/@version@/Proxyman_@version@.dmg" \
        pkgs/by-name/pr/proxyman/darwin.nix aarch64-darwin darwin)

      ${lib.getExe jq} -n "$linuxChanges + $darwinChanges"
    '';
    supportedFeatures = [ "commit" ];
  };

  meta = {
    description = "Capture, inspect, and manipulate HTTP(s) requests/responses with ease";
    homepage = "https://proxyman.com";
    license = lib.licenses.unfree;
    mainProgram = "proxyman";
    maintainers = with lib.maintainers; [
      nilathedragon
      matteopacini
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname updateScript meta; }
else
  callPackage ./linux.nix { inherit pname updateScript meta; }
