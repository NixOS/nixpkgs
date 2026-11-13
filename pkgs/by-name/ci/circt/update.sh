#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=. -i bash -p bash coreutils gnugrep jq gnused nix nix-prefetch-git nix-prefetch-github common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(realpath "$ROOT/../../../..")"
cd "$REPO_ROOT"

# Make the checkout available to the nested Nix invocations as well.
export NIX_PATH="nixpkgs=$REPO_ROOT${NIX_PATH:+:$NIX_PATH}"

attrPath="${UPDATE_NIX_ATTR_PATH:-circt}"

# CIRCT publishes firtool releases as firtool-<version> Git tags. Find the
# highest version rather than relying on the ordering returned by GitHub.
latestVersion=$(
  list-git-tags --url=https://github.com/llvm/circt.git |
    sed -n 's/^firtool-//p' |
    sort --version-sort |
    tail -n1
)
currentVersion="${UPDATE_NIX_OLD_VERSION:-$(nix-instantiate --eval --strict --raw -A "$attrPath.version" .)}"

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "CIRCT is up to date: $currentVersion"
  exit 0
fi

echo "updating CIRCT from $currentVersion to $latestVersion"
update-source-version "$attrPath" "$latestVersion"

# Build only the updated source derivation so its CMakeLists.txt can tell us
# which exact slang revision this CIRCT release expects.
src=$(nix-build --no-out-link -A "$attrPath.src")

# CMakeLists.txt contains several FetchContent declarations and therefore
# several GIT_TAG lines. First isolate the declaration for the slang repository,
# then extract its nearby GIT_TAG. The tag may be followed by a comment or end
# immediately after the revision.
slangRev=$(
  grep -A5 "https://github.com/MikePopoloski/slang" "$src/CMakeLists.txt" |
  sed -nE 's/.*GIT_TAG[[:space:]]+([0-9a-f]{40}).*/\1/p' |
  head -n1
)
if [[ -z "$slangRev" ]]; then
  echo "failed to find slang GIT_TAG in $src/CMakeLists.txt" >&2
  exit 1
fi

# Prefetch slang independently because CIRCT's source hash does not cover
# FetchContent dependencies when CIRCT uses a system-provided slang package.
slangHash=$(
  nix-prefetch-github MikePopoloski slang --rev "$slangRev" |
    jq --exit-status --raw-output .hash
)
currentSlangRev=$(nix-instantiate --eval --strict --raw -A "$attrPath.passthru.sv-lang.src.rev" .)
currentSlangHash=$(nix-instantiate --eval --strict --raw -A "$attrPath.passthru.sv-lang.src.outputHash" .)

# Keep the private sv-lang override synchronized with the revision declared by
# CIRCT without changing the version of nixpkgs' general sv-lang package.
if [[ "$currentSlangRev" != "$slangRev" || "$currentSlangHash" != "$slangHash" ]]; then
  echo "updating slang from $currentSlangRev to $slangRev"
  sed -i \
    -e "s|$currentSlangRev|$slangRev|" \
    -e "s|$currentSlangHash|$slangHash|" \
    "$ROOT/sv-lang.nix"
else
  echo "slang is up to date: $slangRev"
fi
