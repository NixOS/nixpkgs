#!/usr/bin/env nix-shell
#!nix-shell -i bash -p ripgrep common-updater-scripts prefetch-npm-deps jq sd

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR/.."
while ! test -f default.nix; do cd .. ; done
NIXPKGS_DIR="$PWD"

new_version="$(
  list-git-tags --url=https://github.com/shufo/blade-formatter \
  | rg '^v([\d.]*)' -r '$1' \
  | sort --version-sort \
  | tail -n1
)"

cd "$NIXPKGS_DIR"
update-source-version blade-formatter "$new_version"

TMPDIR="$(mktemp -d)"
cd "$TMPDIR"

src="$(nix-build --no-link "$NIXPKGS_DIR" -A blade-formatter.src)"
cp $src/package.json .
npm update
cp ./package-lock.json "$PACKAGE_DIR"

prev_npm_hash="$(nix-instantiate "$NIXPKGS_DIR" \
  --eval --json \
  -A blade-formatter.npmDepsHash \
  | jq -r .
)"
new_npm_hash="$(prefetch-npm-deps ./package-lock.json)"

sd --fixed-strings "$prev_npm_hash" "$new_npm_hash" "$PACKAGE_DIR/package.nix"

rm -rf "$TMPDIR"
