#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

website=$(curl -sL https://necessegame.com/server)

version=$(
    echo "$website" \
        | pup 'a[href*="linux64"] text{}' \
        | awk -F'[v ]' '/Linux64/ {print $4"-"$6}' \
        | sort -Vu \
        | tail -n1
)

if [[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+\-[0-9]+$ ]]; then
    version_url=${version//./-}

    # extract the expiring presigned S3 URL for the new zip
    url=$(
        echo "$website" \
            | pup "a[href*=\"linux64-${version_url}\"] attr{href}" \
            | sed 's/\&amp;/\&/g'
    )

    # call API to remote-fetch the zip immediately and keep it cached,
    # then fetch the zip locally to get the SRI hash, then update.
    # fails early if the zip cannot be remote-fetched / cached.
    curl -s --fail-with-body "https://necesse.pwn.sh/cache.php?version=${version_url}" \
        && sri=$(nix-prefetch-url --unpack "$url" | xargs nix hash convert --hash-algo sha256 --to sri) \
        && update-source-version necesse-server "$version" "$sri"
fi
