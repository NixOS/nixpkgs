#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix-update jq

# GitHub tags include many unrelated subpackage versions, making it unreliable to determine the latest mongosh version.
# Fetch the latest mongosh version directly from the npm registry instead.
version="$(curl -fsSL https://registry.npmjs.org/mongosh/latest | jq -r ".version")"

nix-update --version "$version" mongosh
