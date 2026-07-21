#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep nix-update

set -euo pipefail

VERSION=$(curl https://files.wolfsden.cz/releases/acme-client/ | grep -oP 'acme-client-\K\d+\.\d+\.\d+(?=\.tar\.gz)' | sort -V | tail -n1)

echo ">> acme-client: $VERSION"

nix-update --version "$VERSION" acme-client
