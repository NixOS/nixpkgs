#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update common-updater-scripts

nix-update kminion
