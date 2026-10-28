#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update nodejs
# shellcheck shell=bash

set -euo pipefail

version="$(npm view @microsoft/rush version)"
nix-update "$UPDATE_NIX_ATTR_PATH" --version "$version" --build --test
