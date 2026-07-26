#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix
# shellcheck shell=bash
#
# `nix-update piper-tts -u` runs this. It:
#   1. bumps piper-tts itself the normal way (fetchFromGitHub "vX.Y.Z"
#      release tag + hash) by shelling back out to plain `nix-update`
#      (no -u, so it does its regular generic version-bump instead of
#      recursing into this script)
#   2. bumps the g2pW model + bert-base-chinese tokenizer pins that
#      live alongside it in g2pw-model/
#
# Deliberately does NOT `cd` the whole script into its own directory:
# the inner `nix-update` call needs to run with the nixpkgs root as
# cwd (its default `-f ./.` does `import <cwd>`, which needs
# default.nix there — the package dir here only has package.nix).
# Instead we derive the nixpkgs root from this script's own fixed
# location and pass it explicitly via -f, and call the g2pw-model
# script by absolute path.
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
# pkgs/by-name/pi/piper-tts -> up 4 levels -> nixpkgs root
nixpkgs_root="$(cd "$script_dir/../../../.." && pwd)"

nix-update -f "$nixpkgs_root" "${UPDATE_NIX_ATTR_PATH:-piper-tts}"

"$script_dir/g2pw-model/update-g2pw-model.sh"
