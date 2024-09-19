#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=. -i bash -p "python312.withPackages(ps: with ps; [ cuda-redist-lib ])"
# shellcheck shell=bash

set -euo pipefail

trace() { echo >&2 "$@"; }

trace "Regenerating hashes for CUDA manifest files"

regen-manifest-hashes \
    --tensorrt-manifest-dir "./pkgs/development/python-modules/cuda-redist-lib/tensorrt" \
    --output "./pkgs/development/cuda-modules/redist-index/data/manifest-hashes.json"

trace "Done!"