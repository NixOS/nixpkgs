#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnused

set -eou pipefail

nix-update pkgs.goarista --version branch

# nix-update prefixes the version with the latest tag (e.g. the 2020
# per-package release ockafka-v0.0.5, or stray tags like untagged-<hash>).
# None of those describe trunk, so always use 0 as the version prefix.
sed -i -E 's/version = "[^"]*-unstable-/version = "0-unstable-/' pkgs/by-name/go/goarista/package.nix
