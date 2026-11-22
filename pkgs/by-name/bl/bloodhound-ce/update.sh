#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts yarn-berry_4.yarn-berry-fetcher
set -euo pipefail

# get latest version
url="https://github.com/SpecterOps/BloodHound"
bloodhoundVersion="$(list-git-tags --url="$url" | grep -v rc | sort --version-sort | tail -1)"

if [ "v$UPDATE_NIX_OLD_VERSION" = "$bloodhoundVersion" ]; then
  echo "package is up to date!"
  exit
fi

# get azurehound and sharphound versions from upstream dockerfile
dockerfile="$(curl -fsSL "$url/raw/refs/tags/$bloodhoundVersion/dockerfiles/bloodhound.Dockerfile")"
azurehoundVersion="$(grep -oP 'ARG AZUREHOUND_VERSION=v\K.*' <<< "$dockerfile")"
sharphoundVersion="$(grep -oP 'ARG SHARPHOUND_VERSION=v\K.*' <<< "$dockerfile")"

# update azurehound and sharphound versions
nixFile="$(nix-instantiate --eval -A "$UPDATE_NIX_ATTR_PATH.meta.position" | sed -E 's|"(.*):.*|\1|')"
sed -Ei \
  -e "s|(azurehoundVersion =) .*|\1 \"$azurehoundVersion\";|" \
  -e "s|(sharphoundVersion =) .*|\1 \"$sharphoundVersion\";|" \
  "$nixFile"

# update version and source hash
nix-update --version "$bloodhoundVersion" --src-only

# update missing-hashes.json
src="$(nix-build --no-link -A "$UPDATE_NIX_ATTR_PATH.src")"
pkg="$(dirname "$(readlink -f "$0")")"
yarn-berry-fetcher missing-hashes "$src/yarn.lock" >"$pkg/missing-hashes.json"

# update frontend
nix-update --version skip --no-src "$UPDATE_NIX_ATTR_PATH.frontend"

# update main package
nix-update \
  --version skip --no-src \
  --custom-dep azurehound_darwin_amd64 \
  --custom-dep azurehound_darwin_arm64 \
  --custom-dep azurehound_linux_amd64 \
  --custom-dep azurehound_linux_arm64 \
  --custom-dep azurehound_windows_amd64 \
  --custom-dep azurehound_windows_arm64 \
  --custom-dep sharphoundSource
