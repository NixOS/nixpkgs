#!/usr/bin/env nix-shell
#!nix-shell -i bash -p python3 python3.pkgs.toml cargo

set -e

HERE=$(dirname "${BASH_SOURCE[0]}")
NIXPKGS_ROOT="$HERE/../../../.."

# https://unix.stackexchange.com/a/84980/390173
tempdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'update-lockfile')

cd "$tempdir"
nix-build -E "with import (/. + \"${NIXPKGS_ROOT}\") {}; pkgs.rustPlatform.rustcSrc.override { minimalContent = false; }"
RUSTC_SRC="$(pwd)/result" python3 "$HERE/cargo.py"
RUSTC_BOOTSTRAP=1 cargo build || echo "Build failure is expected. All that's needed is the lockfile."

cp Cargo.lock "$HERE"

rm -rf "$tempdir"


