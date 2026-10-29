#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq xh

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

get_download_info() {
    xh --json \
        https://update.equinox.io/check \
        'Accept:application/json; q=1; version=1; charset=utf-8' \
        'Content-Type:application/json; charset=utf-8' \
        app_id=app_c3U4eZcDbjV \
        channel=stable \
        os="$1" \
        goarm= \
        arch="$2" |
        jq --arg sys "$1-$2" '{
        sys: $sys,
        url: .download_url,
        sha256: .checksum,
        version: .release.version
    }'
}

(
    get_download_info linux 386
    get_download_info linux amd64
    get_download_info linux arm
    get_download_info linux arm64
    get_download_info darwin amd64
    get_download_info darwin arm64
) | jq --slurp 'map ({ (.sys): . }) | add' \
    >versions.json
