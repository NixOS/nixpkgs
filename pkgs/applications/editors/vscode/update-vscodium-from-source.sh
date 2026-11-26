#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash cacert common-updater-scripts coreutils curl gnused jq nix nix-prefetch-github

set -euo pipefail

scriptDir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
attr=vscodiumFromSource

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/VSCodium/vscodium/releases/latest | jq -r .tag_name)
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; $attr.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
  echo "package is up-to-date"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl --fail --silent --show-error -L \
  "https://raw.githubusercontent.com/VSCodium/vscodium/refs/tags/$latestVersion/upstream/stable.json" \
  | jq --sort-keys . > "$tmp/stable.json"
vscodeRev=$(jq -r .commit "$tmp/stable.json")

curl --fail --silent --show-error -L \
  "https://raw.githubusercontent.com/Microsoft/vscode/$vscodeRev/.npmrc" > "$tmp/npmrc"
electronVersion=$(sed -nE 's/^target="?([0-9.]+)"?$/\1/p' "$tmp/npmrc")

curl --fail --silent --show-error -L \
  "https://raw.githubusercontent.com/Microsoft/vscode/$vscodeRev/product.json" \
  | jq --arg electronVersion "$electronVersion" \
    '{ electronVersion: $electronVersion, builtInExtensions: [ .builtInExtensions[] | { name, version, sha256, repo } ] }' \
    > "$tmp/meta.json"

srcHash=$(nix-prefetch-github --rev "$latestVersion" VSCodium vscodium | jq -r .hash)
vscodeHash=$(nix-prefetch-github --rev "$vscodeRev" Microsoft vscode | jq -r .hash)

update-source-version "$attr" "$latestVersion" "$srcHash"

mv "$tmp/stable.json" "$scriptDir/vscodium-from-source-stable.json"
mv "$tmp/meta.json" "$scriptDir/vscodium-from-source-meta.json"

update-source-version "$attr" "" "$vscodeHash" --source-key=vscodeSrc --ignore-same-version --ignore-same-hash
update-source-version "$attr" "" --source-key=npmCache --ignore-same-version
