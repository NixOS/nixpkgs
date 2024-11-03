#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
# shellcheck shell=bash

nix-update rhino
"$(nix-build -A rhino.mitmCache.updateScript)"
