#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash cacert curl common-updater-scripts
# shellcheck shell=bash
set -eu -o pipefail

host="https://releases.grapheneos.org"
read -ra metadata <<< "$(curl -s "$host/caiman-stable")"
version=${metadata[0]}

update-source-version graphene-hardened-malloc "$version"
