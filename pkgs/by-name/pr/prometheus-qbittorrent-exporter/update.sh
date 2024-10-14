#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure -p curl jq cacert

set -euo pipefail

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

info=$(curl -LsSf https://pypi.python.org/pypi/prometheus_qbittorrent_exporter/json)

version=$(jq -r .info.version <<< "$info")
sha256=$(jq -r '.urls[] | select(.packagetype == "sdist") | .digests.sha256' <<< "$info")

jq -n \
    --arg version "$version" \
    --arg sha256 "$sha256" \
    '$ARGS.named' \
    | tee "$SCRIPT_DIR"/source-info.json 1>&2

