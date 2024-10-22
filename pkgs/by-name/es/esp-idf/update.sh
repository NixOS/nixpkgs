#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure -p cacert curl jq nurl
# shellcheck shell=bash

set -euo pipefail

# https://stackoverflow.com/a/246128/1368502
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

info_json=$(curl -sSLf https://api.github.com/repos/espressif/esp-idf/releases)
version=$(jq -r 'map(.tag_name) | sort | map(select(contains("-") | not))[-1]' <<< "$info_json")
url=$(jq -r "map(select(.tag_name == \"$version\"))[0].assets[0].browser_download_url" <<< "$info_json")
hash=$(nurl -H "$url")
tools_json=$(curl -sSLf "https://raw.githubusercontent.com/espressif/esp-idf/$version/tools/tools.json")
tools=$(jq -f "$SCRIPT_DIR/tools.jq" <<< "$tools_json")

jq -n \
    --arg version "${version/v}" \
    --arg url "$url" \
    --arg hash "$hash" \
    --argjson tools "$tools" \
    '$ARGS.named' \
    | tee "$SCRIPT_DIR/source-info.json" 1>&2
