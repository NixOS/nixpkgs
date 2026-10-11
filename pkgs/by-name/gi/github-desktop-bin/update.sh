#!/usr/bin/env nix-shell
#! nix-shell -I ../../../.. -i bash -p coreutils curl jq gnused nix

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

apiResponse="$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/desktop/desktop/releases/latest)"

newVersion="$(jq -r .tag_name <<<"$apiResponse" | sed 's|^release-||')"

sed -i -e "/version =/ s|\".*\"|\"$newVersion\"|" package.nix

new_url="$(jq -r .body <<<"$apiResponse" | grep -oE 'https://desktop.githubusercontent.com/releases/.*/GitHubDesktop-arm64\.zip')"
new_hash="sha256:$(nix-prefetch-url --type sha256 "$new_url")"

jq --null-input \
  --arg url "$new_url" \
  --arg hash "$new_hash" \
  '{ url: $url, hash: $hash }' \
  >source.json
