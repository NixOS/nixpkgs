#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq gnused gnugrep common-updater-scripts

set -euo pipefail
update_macos() {
  nix_file="$(dirname "$0")/package.nix"


  cdn_versions_response="$(curl -fsSL "https://clientsettingscdn.roblox.com/v1/client-version/MacPlayer")"
  upstream_version="$(echo "$cdn_versions_response" | jq -r '.version')"
  client_upload_version="$(echo "$cdn_versions_response" | jq -r '.clientVersionUpload')"

  aarch64_url="setup.rbxcdn.com/mac/arm64/$client_upload_version-RobloxPlayer.zip";
  x86_64_url="setup.rbxcdn.com/mac/$client_upload_version-RobloxPlayer.zip";

  current_nix_version=$(
    grep 'version\s*=' "$nix_file" \
    | sed -Ene 's/.*"(.*)".*/\1/p'
  )

  if [[ "$current_nix_version" != "$upstream_version" ]]; then
    archive_url="https://web.archive.org/save"

    archived_aarch64_url=$(curl -s -I -L -o /dev/null "$archive_url/$aarch64_url" -w '%{url_effective}')
    archived_x86_64_url=$(curl -s -I -L -o /dev/null "$archive_url/$x86_64_url" -w '%{url_effective}')

    update-source-version "pkgsCross.x86_64-darwin.roblox" "$upstream_version" "" "$archived_x86_64_url" \
      --file=$nix_file \
      --ignore-same-version

    update-source-version "pkgsCross.aarch64-darwin.roblox" "$upstream_version" "" "$archived_aarch64_url" \
      --file=$nix_file \
      --ignore-same-version
  else
    echo "Roblox is already up to date"
  fi
}

update_macos
