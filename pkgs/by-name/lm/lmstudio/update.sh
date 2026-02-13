#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

for system in "aarch64-darwin darwin/arm64" "x86_64-linux linux/x64"; do
  # shellcheck disable=SC2086
  set -- ${system} # split string into variables $1 and $2

  arch="${1}"
  platform="${2}"

  url=$(curl -ILs -o /dev/null -w %{url_effective} "https://lmstudio.ai/download/latest/${platform}")
  version="$(echo "${url}" | cut -d/ -f6)"
  hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$(nix-prefetch-url "${url}")")

  update-source-version lmstudio "${version}" "${hash}" --system="${arch}" --version-key="version_${arch}" \
    2> >(tee /dev/stderr) | grep -q "nothing to do" && exit
done
