#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts nix-update
# shellcheck shell=bash

set -euo pipefail

# nix-update can't find the stable tags itself: sable-next has no github releases,
# and its nightly tags crowd them out of the tags feed
version=$(list-git-tags --url=https://github.com/SableClient/sable-next |
    grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort --version-sort | tail -n 1)
nix-update "${UPDATE_NIX_ATTR_PATH:-sable-desktop}" --version "${version#v}"
