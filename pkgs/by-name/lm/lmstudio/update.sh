#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

packages="$(curl -s -L "https://lmstudio.ai/" | grep -oE 'https://installers.lmstudio.ai[^"\]*' | sort -u | grep -v \\.exe)"
for system in "aarch64-darwin darwin/arm64" "x86_64-linux linux/x64"; do
  set -- ${system}

  arch="${1}"
  url=$(echo "${packages}" | grep "${2}")
  version="$(echo "${url}" | cut -d/ -f6)"
  hash=$(nix hash convert --hash-algo sha256 "$(nix-prefetch-url "${url}")")

  update-source-version lmstudio "${version}" "${hash}" --system="${arch}" --version-key="version_${arch}"
done
