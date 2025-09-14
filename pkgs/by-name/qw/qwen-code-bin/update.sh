#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure --keep GITHUB_TOKEN -p curl jq cacert nix
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

NIX_FILE="package.nix"
GITHUB_REPO="QwenLM/qwen-code"
ASSET_NAME="gemini.js"
REV_PREFIX="v"

CURRENT_VER=$(grep -oP 'version = "\K[^"]+' "${NIX_FILE}" || {
  echo "Error: Failed to extract version" >&2
  exit 1
})

API_URL="https://api.github.com/repos/${GITHUB_REPO}/releases"

AUTH=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  AUTH=(-u "$GITHUB_TOKEN:x-oauth-basic")
  echo "Using GITHUB_TOKEN for authenticated requests"
else
  echo "No GITHUB_TOKEN set, using anonymous access (rate limited to 60 requests/hour)"
fi

RELEASE_JSON=$(curl --fail -s "${AUTH[@]}" "${API_URL}" || {
  echo "Error: Failed to fetch GitHub releases" >&2
  exit 1
})

LATEST_VER=$(echo "${RELEASE_JSON}" | jq -r '
  map(select(.prerelease == false and .draft == false))
  | map(select(.tag_name | test("-") | not))
  | sort_by(.created_at)
  | last
  | .tag_name // empty
')

if [[ -z "${LATEST_VER}" ]]; then
  echo "Error: No stable release found" >&2
  exit 1
fi

LATEST_VER="${LATEST_VER#"${REV_PREFIX}"}"

[[ "${LATEST_VER}" == "${CURRENT_VER}" ]] && {
  echo "Already up-to-date: ${CURRENT_VER}"
  exit 0
}

ASSET_URL=$(echo "${RELEASE_JSON}" | jq -r ".[] | select(.tag_name == \"${REV_PREFIX}${LATEST_VER}\") | .assets[] | select(.name == \"${ASSET_NAME}\") | .browser_download_url")
[[ -z "${ASSET_URL}" ]] && {
  echo "Error: Asset ${ASSET_NAME} not found for version ${LATEST_VER}" >&2
  exit 1
}

RAW_HASH=$(nix-prefetch-url "${ASSET_URL}")
LATEST_HASH=$(nix hash to-base64 "sha256:$RAW_HASH")

sed -i "s|hash = \"[^\"]*\"|hash = \"sha256-${LATEST_HASH}\"|g" "${NIX_FILE}"
sed -i "s|version = \"${CURRENT_VER}\"|version = \"${LATEST_VER}\"|g" "${NIX_FILE}"

echo "Successfully updated to version ${LATEST_VER}"
