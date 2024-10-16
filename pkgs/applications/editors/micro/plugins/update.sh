#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep jq nix-prefetch findutils

set -euo pipefail
#set -x

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

function official_plugin_channel_repos {
    # fetch list of repos, filter json5 comments, extract urls
    curl 'https://raw.githubusercontent.com/micro-editor/plugin-channel/master/channel.json' \
        | grep -v '^ *// ' \
        | jq '.[]' --raw-output \
        | grep -v "a11ce/micro-yapf"
}

function unofficial_repos {
    # The official plugin channel is kinda unresponsive
    # Echo additional urls here to add packages from 3rd party repositories

    # https://github.com/micro-editor/plugin-channel/pull/81
    echo "https://raw.githubusercontent.com/MuratovAS/micro-yosyslint/main/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/80
    echo "https://raw.githubusercontent.com/MuratovAS/micro-fzfinder/main/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/79
    echo "https://raw.githubusercontent.com/lukhof/splitterm/main/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/68
    echo "https://raw.githubusercontent.com/serge-v/micro-delve/main/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/70
    echo "https://raw.githubusercontent.com/kesslern/micro-emacs-select/main/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/72
    echo "https://raw.githubusercontent.com/xxuejie/micro-acme/main/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/75
    echo "https://raw.githubusercontent.com/sebkolind/micro-linter-typescript/master/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/77
    echo "https://raw.githubusercontent.com/sebkolind/micro-prettier/master/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/78
    echo "https://raw.githubusercontent.com/sebkolind/micro-ag/master/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/44
    echo "https://raw.githubusercontent.com/ibotdeu/exec-plugin/master/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/42
    echo "https://raw.githubusercontent.com/pennie-quinn/micro-plugin-autosave/master/repo.json"

    # https://github.com/micro-editor/plugin-channel/pull/33
    echo "https://raw.githubusercontent.com/dwwmmn/micro-sunny-day/master/repo.json"
}

# concat repo urls, sort, fetch each, join, write
cat <(official_plugin_channel_repos) \
    <(unofficial_repos) \
    | sort \
    | xargs -d '\n' -n 1 -P 4 curl \
    | jq -s add \
    > "$SCRIPT_DIR"/plugin-repos.json

# for each url, download + compute hash, format, join, write
<"$SCRIPT_DIR"/plugin-repos.json jq '.[] | .Versions[] | .Url' --raw-output | sort |
while read url; do
    #if HASH="$(nix-prefetch-url --quiet --unpack "$url")"; then
    if HASH="$(nix-prefetch fetchzip --stripRoot --expr false --url "$url")"; then
        echo "$url" | jq --raw-input "{(.): \"$HASH\"}"
    else
        echo "$url" | jq --raw-input "{(.): null}"
    fi
done \
    | jq -s add \
    > "$SCRIPT_DIR"/plugin-hashes.json

echo "Done!"
