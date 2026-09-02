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

  url=$(curl -ILs -o /dev/null -w %{url_effective} "https://lmstudio.ai/download/bionic/latest/${platform}")
  version="$(echo "${url}" | cut -d/ -f6)"
  hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$(nix-prefetch-url "${url}")")

  if update-source-version lmstudio-bionic "${version}" "${hash}" --system="${arch}" --version-key="version_${arch}" \
      2> >(tee /dev/stderr) | grep -q "nothing to do"; then
    continue
  fi
done
