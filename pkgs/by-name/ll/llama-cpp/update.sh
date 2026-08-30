#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gitMinimal gnused nix-update
# shellcheck shell=bash

set -euo pipefail

repo_url="https://github.com/ggml-org/llama.cpp.git"

version="$({
  git ls-remote --refs --tags "$repo_url" 'refs/tags/v*' \
    | sed -nE 's|^[^[:space:]]+[[:space:]]+refs/tags/v([0-9]+\.[0-9]+\.[0-9]+)$|\1|p' \
    | sort -V \
    | tail -n1
})"

if [[ -z "$version" ]]; then
  echo "Failed to find the latest semantic version tag" >&2
  exit 1
fi

tag_refs="$(
  git ls-remote --tags "$repo_url" \
    "refs/tags/v$version" "refs/tags/v$version^{}" 'refs/tags/b*'
)"
release_commit="$(
  awk -v ref="refs/tags/v$version^{}" '$2 == ref { print $1 }' <<<"$tag_refs"
)"
if [[ -z "$release_commit" ]]; then
  release_commit="$(
    awk -v ref="refs/tags/v$version" '$2 == ref { print $1 }' <<<"$tag_refs"
  )"
fi
build_number="$({
  awk -v commit="$release_commit" '
    $1 == commit && $2 ~ /^refs\/tags\/b[0-9]+(\^\{\})?$/ {
      sub(/^refs\/tags\/b/, "", $2)
      sub(/\^\{\}$/, "", $2)
      print $2
    }
  ' <<<"$tag_refs" | sort -n | tail -n1
})"

if [[ -z "$release_commit" || -z "$build_number" ]]; then
  echo "Failed to find the build number for v$version" >&2
  exit 1
fi

cd "$(git rev-parse --show-toplevel)"
nix-update "${UPDATE_NIX_ATTR_PATH:-llama-cpp}" --version "$version"
sed -i -E \
  's|(buildNumber = ")[0-9]+(";)|\1'"$build_number"'\2|' \
  pkgs/by-name/ll/llama-cpp/package.nix
