#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnugrep curl jq gnused

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

NIX_FILE="package.nix"
RELEASE_ID="latest"

GITHUB_REPO="$1"
ASSET_NAME="$2"
REV_PREFIX="${3:-v}"

CURRENT_VER="$(grep -oP 'version = "\K[^"]+' "${NIX_FILE}")"
CURRENT_HASH="$(grep -oP 'hash = "\K[^"]+' "${NIX_FILE}")"
{
    read -r LATEST_VER
    read -r ASSET_DIGEST
} < <(curl --fail -s ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} "https://api.github.com/repos/${GITHUB_REPO}/releases/${RELEASE_ID}" | jq -r ".tag_name, (.assets[] | select(.name == \"${ASSET_NAME}\") | .digest)")

LATEST_VER="${LATEST_VER#"${REV_PREFIX}"}"

if [[ "${LATEST_VER}" == "${CURRENT_VER}" ]]; then
    echo "Up to date."
    exit 0
fi

LATEST_HASH="$(nix-hash --to-sri "${ASSET_DIGEST}")"

sed -i "s#hash = \"${CURRENT_HASH}\";#hash = \"${LATEST_HASH}\";#g" "${NIX_FILE}"
sed -i "s#version = \"${CURRENT_VER}\";#version = \"${LATEST_VER}\";#g" "${NIX_FILE}"

echo "Successfully updated from ${CURRENT_VER} to version ${LATEST_VER}."
