#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl common-updater-scripts nix-prefetch jq
# shellcheck shell=bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

LATEST_DEB=$(curl -s https://repo.cider.sh/apt/pool/main/ | \
    grep -oP 'cider-v(\d+\.\d+\.\d+)-linux-x64\.deb' | \
    sort -rV | head -n 1)

if [[ -z "$LATEST_DEB" ]]; then
  echo "Could not find latest Cider .deb!" >&2
  exit 1
fi

NEW_VERSION=$(echo "$LATEST_DEB" | sed -E 's|cider-v([0-9.]+)-linux-x64\.deb|\1|')
DEB_URL="https://repo.cider.sh/apt/pool/main/${LATEST_DEB}"

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
    SHA="$(nix-prefetch-url --quiet --type sha256 $DEB_URL)"
    SRI=$(nix --experimental-features nix-command hash to-sri "sha256:$SHA")
    update-source-version cider-2 "$NEW_VERSION" "$SRI"
fi
