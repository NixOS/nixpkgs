#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../.. -i bash -p wget yarn2nix-moretea.yarn2nix jq
# shellcheck shell=bash

# This script is based upon:
# pkgs/applications/networking/instant-messengers/riot/update-riot-desktop.sh

set -euo pipefail

if [[ $# -ne 1 || $1 == -* ]]; then
    echo "Regenerates the Yarn dependency lock files for the powerdns-admin package."
    echo "Usage: $0 <git release version>"
    exit 1
fi

WEB_SRC="https://raw.githubusercontent.com/ngoduykhanh/PowerDNS-Admin/v$1"

wget "$WEB_SRC/package.json" -O - | jq ".name = \"powerdns-admin-assets\" | .version = \"$1\"" > package.json
wget "$WEB_SRC/yarn.lock" -O yarn.lock
yarn2nix --lockfile=yarn.lock > yarndeps.nix
rm yarn.lock
