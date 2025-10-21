#!/usr/bin/env nix-shell
#!nix-shell --pure --keep NIX_PATH -i bash --packages nodejs nix-update git

set -euo pipefail

version=$(npm view @anthropic-ai/claude-code version)

# Update version and hashes
AUTHORIZED=1 NIXPKGS_ALLOW_UNFREE=1 nix-update claude-code --version="$version" --generate-lockfile
nix-update vscode-extensions.anthropic.claude-code --use-update-script --version "$version"
