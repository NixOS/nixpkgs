#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

nix-update pakku
$(nix-build -A pakku.mitmCache.updateScript)
