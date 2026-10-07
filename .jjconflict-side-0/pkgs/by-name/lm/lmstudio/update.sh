#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

SUPPORTED_SYSTEMS=(
  "aarch64-darwin darwin/arm64"
  "x86_64-linux linux/x64"
  "aarch64-linux linux/arm64"
)

for system in "${SUPPORTED_SYSTEMS[@]}"; do
  # shellcheck disable=SC2086
  set -- ${system} # split string into variables $1 and $2

  arch="${1}"
  platform="${2}"

  url=$(curl -fILs -o /dev/null -w '%{url_effective}' "https://lmstudio.ai/download/latest/${platform}")
  version="$(echo "${url}" | cut -d/ -f6)"

  # compare versions before fetching, the installers are ~1 GB each
  currentVersion=$(nix-instantiate --eval --raw --argstr system "${arch}" -A lmstudio.version)
  if [[ "${currentVersion}" == "${version}" ]]; then
    echo "lmstudio (${arch}) is up-to-date: ${version}"
    continue
  fi

  hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$(nix-prefetch-url "${url}")")

  # any failure propagates via set -e
  update-source-version lmstudio "${version}" "${hash}" --system="${arch}" --version-key="version_${arch}"
done
