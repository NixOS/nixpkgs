#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

nix-update stirling-pdf
DISABLE_ADDITIONAL_FEATURES=true $(nix-build -A stirling-pdf.mitmCache.updateScript)

