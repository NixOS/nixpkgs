#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gitMinimal gnused jq nix-update
# shellcheck shell=bash

set -euo pipefail

repo="ggml-org/llama.cpp"
api="https://api.github.com/repos/$repo"
package="pkgs/by-name/ll/llama-cpp/package.nix"

github() {
  # shellcheck disable=SC2086
  curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$@"
}

set_attr() {
  sed -i -E "s|($1 = \")[^\"]*|\1$2|" "$package"
  grep -q "$1 = \"$2\";" "$package" || {
    echo "failed to set $1 in $package" >&2
    exit 1
  }
}

# The bNNNNN nightly releases are pre-releases, so the latest release is the newest semantic version.
# Upstream only started flagging them as such at the v0.2.0 cutover, hence the shape check.
version="$(github "$api/releases/latest" | jq -er '.tag_name | ltrimstr("v") | select(test("^[0-9]+(\\.[0-9]+)+$"))')" || {
  echo "latest release is not a semantic version" >&2
  exit 1
}

# llama.cpp reads the build number from git, which the release tarball does not ship.
# Every release carries the matching nightly tag as an asset.
build_number="$(github "https://github.com/$repo/releases/download/v$version/nightly-tag.txt")"

cd "$(git rev-parse --show-toplevel)"
nix-update "${UPDATE_NIX_ATTR_PATH:-llama-cpp}" --version "$version"
set_attr buildNumber "${build_number#b}"
