#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl cacert nix common-updater-scripts --pure
#shellcheck shell=bash

set -eu -o pipefail

# upstream doesn't use git, but has this file specifically for versioning
version="$(curl https://lib25519.cr.yp.to/lib25519-latest-version.txt)"

update-source-version lib25519 "$version"
