#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch-git common-updater-scripts jq prefetch-npm-deps ripgrep

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

REPO="advplyr/audiobookshelf"

NEW_VER=$(list-git-tags --url=https://github.com/$REPO | rg 'v[0-9\.]*$' | sed -e 's/^v//' | sort -V | tail -n 1)
OLD_VER=$(nix-instantiate --eval -A audiobookshelf.version | jq --exit-status --raw-output)

if [ "$NEW_VER" == "$OLD_VER" ]; then
  echo "No update needed."
  exit 0
fi

replace_hash() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

get_npm_hash() {
  pushd "$(mktemp -d)" >/dev/null
  curl -s "https://raw.githubusercontent.com/$REPO/v$NEW_VER/$1" -o package-lock.json
  prefetch-npm-deps package-lock.json
  rm -f package-lock.json
  popd >/dev/null
}

src_hash() {
  nix-prefetch-git --url https://github.com/$REPO --rev "refs/tags/v${NEW_VER}" | jq --exit-status --raw-output .hash
}

sed -i "s/version = \".*\"/version = \"$NEW_VER\"/" "$NIX_DRV"
replace_hash "hash" "$(src_hash)"
replace_hash "npmDepsHash" "$(get_npm_hash "package-lock.json")"
replace_hash "clientNpmDepsHash" "$(get_npm_hash "client/package-lock.json")"
