#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p nix-update
#shellcheck shell=bash

set -euo pipefail

export NIXPKGS_ALLOW_INSECURE=1 # package has knownVulnerabilities
export NIXPKGS_ALLOW_UNFREE=1 # package includes unfree dependencies
nix-update "$UPDATE_NIX_ATTR_PATH"
