#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl jq

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl_github() {
  local auth=()
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    auth=(--user ":$GITHUB_TOKEN")
  fi
  curl --fail-with-body --location --silent --show-error "${auth[@]}" "$@"
}

releaseInfo="$(curl_github "https://api.github.com/repos/stashapp/stash/releases/latest")"

releaseTag="$(jq -r '.tag_name' <<< "$releaseInfo")"
releaseDate="$(jq -r '.published_at' <<< "$releaseInfo")"
commitInfo="$(curl_github "https://api.github.com/repos/stashapp/stash/commits/$releaseTag")"

appDate="$(date -u -d "$releaseDate" '+%Y-%m-%d %H:%M:%S')"
version="${releaseTag#v}"
gitHash="$(jq -r '.sha[0:8]' <<< "$commitInfo")"

sed -E -i \
  -e "s|^(  appDate = \").*(\";)$|\1$appDate\2|" \
  -e "s|^(  gitHash = \").*(\";)$|\1$gitHash\2|" \
  "$SCRIPT_DIR/package.nix"

grep -qxF "  appDate = \"$appDate\";" "$SCRIPT_DIR/package.nix"
grep -qxF "  gitHash = \"$gitHash\";" "$SCRIPT_DIR/package.nix"

nix-update "${UPDATE_NIX_ATTR_PATH:-stash}" --subpackage frontend --version "$version"

grep -qxF "  version = \"$version\";" "$SCRIPT_DIR/package.nix"
