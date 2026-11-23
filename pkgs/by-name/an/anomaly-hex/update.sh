#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash nix-update

set -euo pipefail

# Linux: version, source hash and cargoHash
nix-update --system x86_64-linux anomaly-hex

# Darwin: refresh the prebuilt zip hash for the version set above
nix-update --system aarch64-darwin --version=skip --src-only anomaly-hex
