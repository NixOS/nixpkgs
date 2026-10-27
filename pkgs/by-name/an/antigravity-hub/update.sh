#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts curl jq nix yq-go

set -euo pipefail

packageFile=pkgs/by-name/an/antigravity-hub/package.nix
manifestBaseUrl=https://antigravity-hub-auto-updater-974169037036.us-central1.run.app/manifest

# Download URLs embed a build ID next to the version, e.g.
# https://storage.googleapis.com/antigravity-public/antigravity-hub/2.12.2-6298742303883264/linux-x64/Antigravity.AppImage
readManifest() {
    local manifest url
    manifest=$(curl -sSfL "$manifestBaseUrl/$1.yml")
    read -r version url < <(yq '.version + " " + .files[0].url' <<<"$manifest")
    buildId=$(cut -d/ -f6 <<<"$url" | cut -d- -f2)
}

# All platforms share one version and build ID, so only update once both
# manifests agree.
readManifest latest-x64-linux
latestVersion=$version
latestBuildId=$buildId
readManifest latest-arm64-mac
if [[ "$version-$buildId" != "$latestVersion-$latestBuildId" ]]; then
    echo "Linux ($latestVersion-$latestBuildId) and macOS ($version-$buildId) releases differ, not updating" >&2
    exit 1
fi

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

for system in x86_64-linux aarch64-linux aarch64-darwin; do
    url=$(nix-instantiate --eval --raw --system "$system" -E "with import ./. {}; antigravity-hub.src.url")
    hash=$(nix store prefetch-file --json "$url" | jq -r .hash)
    update-source-version antigravity-hub "$latestVersion" "$hash" --system="$system" --ignore-same-version
done
