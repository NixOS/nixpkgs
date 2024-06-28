#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -eu -o pipefail

die() {
    echo "updater.sh: error $1" >&2
    exit 1
}

url=$(curl "https://chatzone.o3team.ru/apps/mattermost-desktop-setup-latest-linux" -sLI -o /dev/null -w '%{url_effective}')
if [ -z "${url}" ]; then
    die "Failed to resolve AppImage URL"
fi

version=$(echo "$url" | perl -pe 's/^https:\/\/[\w-]+(?:\.[\w-]+)*\/(?:[\w-]+\/)*chatzone-desktop-linux-(\d+\.\d+\.\d+).AppImage$/\1/sgu')
if [ -z "${version}"  ]; then
    die "Failed to parse version from URL: ${url}"
fi

update-source-version chatzone-desktop "$version" "" "$url" --file=./pkgs/by-name/ch/chatzone-desktop/package.nix --source-key=src.src

