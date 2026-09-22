#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts curl jq nix yq-go

set -euo pipefail

packageFile=pkgs/by-name/an/antigravity-hub/package.nix
manifestUrl=https://antigravity-hub-auto-updater-974169037036.us-central1.run.app/manifest/latest-x64-linux.yml

# Download URLs embed a build ID next to the version, e.g.
# https://storage.googleapis.com/antigravity-public/antigravity-hub/2.12.2-6298742303883264/linux-x64/Antigravity.AppImage
manifest=$(curl -sSfL "$manifestUrl")
read -r latestVersion latestUrl < <(yq '.version + " " + .files[0].url' <<<"$manifest")
latestBuildId=$(cut -d/ -f6 <<<"$latestUrl" | cut -d- -f2)

currentVersion=$(nix-instantiate --eval --raw -E "with import ./. {}; antigravity-hub.version")
if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "antigravity-hub is up-to-date: $currentVersion"
    exit 0
fi

# Bump the version and build ID first so that src.url evaluates to the new downloads.
sed -i \
    -e "s/version = \"$currentVersion\";/version = \"$latestVersion\";/" \
    -e "s/buildId = \"[0-9]*\";/buildId = \"$latestBuildId\";/" \
    "$packageFile"

for system in x86_64-linux aarch64-linux; do
    url=$(nix-instantiate --eval --raw --system "$system" -E "with import ./. {}; antigravity-hub.src.url")
    hash=$(nix store prefetch-file --json "$url" | jq -r .hash)
    update-source-version antigravity-hub "$latestVersion" "$hash" --system="$system" --ignore-same-version
done
