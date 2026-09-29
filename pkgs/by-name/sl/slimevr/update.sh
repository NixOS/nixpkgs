#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

nix-update slimevr
$(nix-build -A slimevr-server.mitmCache.updateScript)
