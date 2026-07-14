#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl yq-go jq

set -euo pipefail

base="https://api.k8slens.dev/binaries"

# Lens is built with electron-builder, which publishes an auto-update manifest
# next to each binary. These manifests carry both the latest version and the
# base64 sha512 digest of every artifact, so we can bump all platforms without
# downloading the (~250 MiB) images ourselves.
linux_manifest=$(curl -sfL "$base/latest-linux.yml" | yq -o=json)
mac_manifest=$(curl -sfL "$base/latest-mac.yml" | yq -o=json)

# The manifest reports e.g. "2026.6.260931-latest"; the "-latest" suffix only
# lives in the download URL, so drop it from the Nix version.
version=$(jq -r '.version' <<<"$linux_manifest")
version=${version%-latest}

# electron-builder records base64-encoded sha512 digests, which are already
# valid Nix SRI hashes once prefixed with "sha512-". Match artifacts by filename
# suffix (endswith) rather than a regex to keep jq's string escaping out of play.
manifest_hash() {
  echo "sha512-$(jq -r --arg suffix "$1" '.files[] | select(.url | endswith($suffix)) | .sha512' <<<"$2" | head -n1)"
}

appimage_hash=$(manifest_hash '.x86_64.AppImage' "$linux_manifest")
dmg_hash=$(manifest_hash '-latest.dmg' "$mac_manifest")
arm64_dmg_hash=$(manifest_hash '-arm64.dmg' "$mac_manifest")

# The three platforms share one version but have distinct hashes. --system picks
# which source (and therefore which hash) update-source-version rewrites; passing
# the hash explicitly avoids a download. The version is written on the first call,
# so the darwin calls need --ignore-same-version to not early-exit as "unchanged".
update-source-version lens "$version" "$appimage_hash" --system=x86_64-linux
update-source-version lens "$version" "$dmg_hash" --system=x86_64-darwin --ignore-same-version
update-source-version lens "$version" "$arm64_dmg_hash" --system=aarch64-darwin --ignore-same-version
