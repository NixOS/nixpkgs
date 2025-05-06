#! /usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts prefetch-npm-deps jq sd nodejs
#shellcheck shell=bash

set -xeu -o pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

cd "${SCRIPT_DIRECTORY}/.."
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
cp ./package-lock.json "${SCRIPT_DIRECTORY}"

prev_npm_hash="$(nix-instantiate "$NIXPKGS_DIR" \
  --eval --json \
  -A collabora-online.npmDeps.hash \
  | jq -r .
)"
new_npm_hash="$(prefetch-npm-deps ./package-lock.json)"

sd --fixed-strings "$prev_npm_hash" "$new_npm_hash" "${SCRIPT_DIRECTORY}/package.nix"
