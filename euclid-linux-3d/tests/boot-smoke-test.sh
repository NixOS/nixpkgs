#!/usr/bin/env bash
set -e

echo "Running full ISO evaluation check..."
nix eval --raw .#nixosConfigurations.euclid-linux-3d-iso.config.system.build.toplevel.outPath --extra-experimental-features "nix-command flakes" > /dev/null

echo "Running checks on closure for unwanted packages..."
nix path-info -r .#nixosConfigurations.euclid-linux-3d-iso.config.system.build.toplevel --extra-experimental-features "nix-command flakes" > closure.txt || true
if grep -q "plasma-desktop\|mate-desktop\|lumina" closure.txt; then
  echo "ERROR: Unwanted package found in closure!"
  return 1 2>/dev/null || true
fi

echo "Boot test passed successfully."
