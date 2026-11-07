#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq gnused gnugrep common-updater-scripts

set -euo pipefail
nix_file="$(dirname "$0")/package.nix"

update_macos() {
  cdn_versions_response="$(curl -fsSL "https://clientsettingscdn.roblox.com/v1/client-version/MacPlayer")"
  upstream_version="$(echo "$cdn_versions_response" | jq -r '.version')"
  client_upload_version="$(echo "$cdn_versions_response" | jq -r '.clientVersionUpload')"
  url="setup.rbxcdn.com/mac/arm64/$client_upload_version-RobloxPlayer.zip";

  current_nix_version=$(
    grep 'version\s*=' "$nix_file" \
    | sed -Ene 's/.*"(.*)".*/\1/p'
  )

  if [[ "$current_nix_version" != "$upstream_version" ]]; then
    archive_url="https://web.archive.org/save"
    archived_url=$(curl -s -I -L -o /dev/null "$archive_url/$url" -w '%{url_effective}')

    update-source-version "pkgsCross.aarch64-darwin.roblox" "$upstream_version" "" "$archived_url" \
      --file=$nix_file \
      --ignore-same-version
  fi
}

update_macos
