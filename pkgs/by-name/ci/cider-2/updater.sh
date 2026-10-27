#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl common-updater-scripts nix-prefetch jq
# shellcheck shell=bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

NEW_VERSION=$(curl -s https://repo.cider.sh/apt/pool/main/ |
  grep -oP 'cider-v(\d+\.\d+\.\d+(?:\.\d+)?)-linux-x64\.deb' |
  sed -E 's|cider-v([0-9.]+)-linux-x64\.deb|\1|' |
  sort -rV | head -n 1)

if [[ -z "$NEW_VERSION" ]]; then
  echo "Could not find latest Cider .deb!" >&2
  exit 1
fi

X64_DEB_URL="https://repo.cider.sh/apt/pool/main/cider-v${NEW_VERSION}-linux-x64.deb"
ARM64_DEB_URL="https://repo.cider.sh/apt/pool/main/cider-v${NEW_VERSION}-linux-arm64.deb"

OLD_VERSION="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./package.nix)"

echo "comparing versions $OLD_VERSION -> $NEW_VERSION"
if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
  echo "Already up to date!"
  if [[ "${1-default}" != "--deps-only" ]]; then
    exit 0
  fi
fi

cd ../../../..

if [[ "${1-default}" != "--deps-only" ]]; then
  X64_SHA="$(nix-prefetch-url --quiet --type sha256 $X64_DEB_URL)"
  ARM64_SHA="$(nix-prefetch-url --quiet --type sha256 $ARM64_DEB_URL)"
  X64_SRI=$(nix --experimental-features nix-command hash convert --hash-algo sha256 --to sri "$X64_SHA")
  ARM64_SRI=$(nix --experimental-features nix-command hash convert --hash-algo sha256 --to sri "$ARM64_SHA")
  update-source-version cider-2 "$NEW_VERSION" "$X64_SRI"  --system=x86_64-linux
  update-source-version cider-2 "$NEW_VERSION" "$ARM64_SRI" --system=aarch64-linux --ignore-same-version
fi
