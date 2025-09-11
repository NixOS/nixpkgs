#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnused

set -eou pipefail

nix-update pkgs.goarista --version branch

# The last github release in 2020 was named ockafka-v0.0.5.
# I don't want this in the version name, it's from when Arista
# was doing per-package releases in the repo, and not just trunk
sed -i 's/ockafka-v0\.0\.5-/0-/' pkgs/by-name/go/goarista/package.nix
