#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gitMinimal gnused common-updater-scripts nix nix-update
# shellcheck shell=bash

# The CLI crates have no releases of their own, so the packages built from this
# workspace follow Buzz Desktop releases (desktop-v* tags), which ship these
# binaries. They inherit the source and Cargo hash from buzz-cli.

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

repo="block/buzz"

github() {
  # shellcheck disable=SC2086
  curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$@"
}

tag="$(github "https://api.github.com/repos/$repo/releases?per_page=100" |
  jq -r '[.[] | select((.draft or .prerelease) | not) | .tag_name | select(test("^desktop-v[0-9.]+$"))][0]')"
date="$(github "https://api.github.com/repos/$repo/commits/$tag" | jq -r .commit.committer.date | cut -dT -f1)"
base="$(github "https://raw.githubusercontent.com/$repo/$tag/Cargo.toml" |
  sed -n '/^\[workspace\.package\]/,/^\[/ s/^version = "\(.*\)"$/\1/p')"

sed -i "s|tag = \"desktop-v[^\"]*\";|tag = \"$tag\";|" pkgs/by-name/bu/buzz-cli/package.nix
update-source-version buzz-cli "$base-unstable-$date"
nix-update buzz-cli --version skip
