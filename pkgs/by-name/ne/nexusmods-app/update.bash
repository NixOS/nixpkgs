#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p nix-update
#shellcheck shell=bash

set -o errexit -o nounset -o pipefail

package=nexusmods-app
nix-update "$package"
"$(nix-build --attr "$package".fetch-deps --no-out-link)"
