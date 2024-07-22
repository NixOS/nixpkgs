#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p nix-update nixfmt-rfc-style
#shellcheck shell=bash

set -o errexit -o nounset -o pipefail

package=nexusmods-app
nix-update "$package"
"$(nix-build --attr "$package".fetch-deps --no-out-link)"
nixfmt "pkgs/by-name/${package:0:2}/$package"
