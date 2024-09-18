#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl
# shellcheck shell=bash

set -eu -o pipefail

# The first valid version in the changelog should always be the latest version.
version="$(curl https://www.der-hammer.info/terminal/CHANGELOG.txt | grep -m1 -Po '[0-9]+\.[0-9]+\.[0-9]+')"

function update_hash_for_system() {
    local system="$1"
    # Reset the version number so the second architecture update doesn't get ignored.
    update-source-version hterm 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" --system="$system"
    update-source-version hterm "$version" --system="$system"
}

update_hash_for_system x86_64-linux
update_hash_for_system i686-linux
