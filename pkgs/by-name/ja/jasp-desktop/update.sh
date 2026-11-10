#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
#shellcheck shell=bash
set -euo pipefail

pkg_dir="$(dirname "$0")"

nix-update jasp-desktop
"$pkg_dir/generate-module-info.sh"
