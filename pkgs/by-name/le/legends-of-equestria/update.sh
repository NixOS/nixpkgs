#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -eu -o pipefail

DOWNLOADS_PAGE_URL=https://www.legendsofequestria.com/downloads
REGEX='href="(https.+)".+Linux.+v(([0-9]+\.)+[0-9]+)'

if [[ $(curl -s $DOWNLOADS_PAGE_URL | grep -Fi Linux) =~ $REGEX ]]; then
    url="${BASH_REMATCH[1]}"
    version="${BASH_REMATCH[2]}"
else
    echo "cannot find the latest version"
    exit 1
fi

update-source-version legends-of-equestria "$version" "" "$url"
