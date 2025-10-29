#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nodejs prefetch-npm-deps sd

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR/.."
while ! test -f flake.nix; do cd .. ; done
NIXPKGS_DIR="$PWD"

latest_commit="$(
  curl -L -s ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} https://api.github.com/repos/less/less-plugin-clean-css/branches/master \
  | jq -r .commit.sha
)"

# This repository does not report it's version in tags
version="$(
  curl https://raw.githubusercontent.com/less/less-plugin-clean-css/$latest_commit/package.json \
  | jq -r .version
)"
update-source-version lessc.plugins.clean-css "$version" --rev=$latest_commit

src="$(nix-build --no-link "$NIXPKGS_DIR" -A lessc.plugins.clean-css.src)"

prev_npm_hash="$(
  nix-instantiate "$NIXPKGS_DIR" \
  --eval --json -A lessc.plugins.clean-css.npmDepsHash \
  | jq -r .
)"
new_npm_hash="$(prefetch-npm-deps "$src/package-lock.json")"
sd --fixed-strings "$prev_npm_hash" "$new_npm_hash" "$PACKAGE_DIR/default.nix"
