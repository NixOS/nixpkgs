#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=. -i bash -p "python312.withPackages(ps: with ps; [ cuda-redist-lib ])"
# shellcheck shell=bash

set -euo pipefail

trace() { echo >&2 "$@"; }

trace "Copying manifest files to tree"

export TENSORRT_MANIFEST_DIR="./pkgs/development/python-modules/cuda-redist-lib/tensorrt"
export MANIFEST_HASHES_JSON_PATH="./pkgs/development/cuda-modules/redist-index/data/manifest-hashes.json"
regen-manifest-hashes

trace "Done!"