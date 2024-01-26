#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
#shellcheck shell=bash
nix-update -u yuzuPackages.nx_tzdb "$@"
nix-update -u yuzuPackages.compat-list "$@"
nix-update -u yuzuPackages.mainline "$@"
nix-update -u yuzuPackages.early-access "$@"
