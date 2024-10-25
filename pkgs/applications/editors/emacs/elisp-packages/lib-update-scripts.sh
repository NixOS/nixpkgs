#!/usr/bin/env bash

# This script is a basic library that concentrates the main tasks of bulk updating:
# - download from Emacs overlay
# - runs update-<packageset>
# - test the packageset
# - commit the changes

SOURCE=${BASH_SOURCE[0]}
# resolve $SOURCE until the file is no longer a symlink
while [ -L "$SOURCE" ]; do
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    # if $SOURCE was a relative symlink, we need to resolve it relative to the
    # path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

download_change() {
    local FILE_LOCATION="$1"

    local BASEURL="https://raw.githubusercontent.com/nix-community/emacs-overlay/master/repos"

    curl -s -O "${BASEURL}/${FILE_LOCATION}"
}

commit_change() {
    local MESSAGE="$1"
    local FILENAME="$2"
    local FROM="$3"

    git diff --exit-code "${FILENAME}" > /dev/null || \
        git commit -m "${MESSAGE}: updated at $(date --iso) (from ${FROM})" -- "${FILENAME}"
}

test_packageset(){
    local PKGSET="$1"

    NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace ${DIR}/../../../../../ -A "emacs.pkgs.$PKGSET"
}
