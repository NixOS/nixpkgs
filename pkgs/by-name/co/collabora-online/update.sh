#! /usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts prefetch-npm-deps jq sd nodejs
#shellcheck shell=bash

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR/.."
while ! test -f default.nix; do cd .. ; done
NIXPKGS_DIR="$PWD"

new_version="$(
  list-git-tags --url=https://github.com/CollaboraOnline/online \
  | grep --perl-regex --only-matching '^cp-\K[0-9.-]+$' \
  | sort --version-sort \
  | tail -n1
)"

cd "$NIXPKGS_DIR"
update-source-version collabora-online "$new_version"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
cd "$TMPDIR"

src="$(nix-build --no-link "$NIXPKGS_DIR" -A collabora-online.src)"
cp "$src"/browser/package.json .
npm install --package-lock-only
cp ./package-lock.json "$PACKAGE_DIR"

prev_npm_hash="$(nix-instantiate "$NIXPKGS_DIR" \
  --eval --json \
  -A collabora-online.npmDeps.hash \
  | jq -r .
)"
new_npm_hash="$(prefetch-npm-deps ./package-lock.json)"

sd --fixed-strings "$prev_npm_hash" "$new_npm_hash" "$PACKAGE_DIR/package.nix"
