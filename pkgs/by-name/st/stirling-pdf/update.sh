#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
# shellcheck shell=bash

set -euo pipefail

# The default package contains upstream's unfree login code. nix-update
# evaluates it while regenerating the Gradle dependency cache.
export NIXPKGS_ALLOW_UNFREE=1

old_version=$(nix-instantiate --eval --raw -A stirling-pdf.version)
nix-update stirling-pdf --use-github-releases --src-only
new_version=$(nix-instantiate --eval --raw -A stirling-pdf.version)

if [[ "$old_version" == "$new_version" ]]; then
  exit 0
fi

# The free server fetches a filtered source tree, so its source hash differs.
nix-update stirling-pdf-free --version skip --src-only

# Regenerate the npm and Cargo hashes and the shared Gradle dependency lock.
# gradleUpdateScript resolves both feature sets and all JPDFium platforms.
nix-update stirling-pdf --version skip --no-src
