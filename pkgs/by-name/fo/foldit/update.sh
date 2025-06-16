#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -x -eu -o pipefail

OLD_PWD="$(pwd)"
cd "$(dirname "$(readlink -f "$0")")"

REQUEST_URL=https://fold.it/api/get_update_components
MERGED_FILE="hot-updates.json"

archiveUrl() {
    url=$1
    curl -o /dev/null -s "https://web.archive.org/save/$url"
    timestamp=$(curl -s "https://archive.org/wayback/available?url=$url" | jq -r '.archived_snapshots.closest.timestamp')
    echo "https://web.archive.org/web/$timestamp/$url"
}

update() {
    platform_name=$1
    platform=$2
    original_url=$3
    prefetch_args=$4

    nix_file="package.nix"
    versions_file="$platform-versions.json"
    hashes_file="$platform-hashes.json"

    new_versions="$(curl -X POST "$REQUEST_URL" \
        -H "Content-Type: application/json" \
        -d '{"platform": "'$platform_name'", "update_group": "main"}' | jq)"

    output="{}"
    while read -r name download; do
        if [ "$(jq -r '.components["'$name'"].version' "$versions_file")" = "$(echo "$new_versions" | jq -r '.components["'$name'"].version')" ]; then
            output="$(echo "$output" | jq --arg name "$name" --arg hash "$(jq -r '.["'$name'"]' "$hashes_file")" '.[$name] = $hash')"
            continue
        fi
        hash=$(nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url "$download"))
        output="$(echo "$output" | jq --arg name "$name" --arg hash "$hash" '.[$name] = $hash')"
    done < <(jq -r '.components | to_entries[] | "\(.key) \(.value.download)"' "$versions_file")
    echo "$output" > "$hashes_file"

    if [ "$(jq -r '.release_id' "$versions_file")" != "$(echo "$new_versions" | jq -r '.release_id')" ]; then
        url=$(archiveUrl "$original_url")
        hash=$(nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url "$prefetch_args" "$original_url"))
        sed -i -E '/'"$(printf '%s\n' "$original_url" | sed 's/[\/&]/\\&/g')"'/ {
            s|^( *url = ")https://[^"]*'"$original_url"'";|\1'"$url"'";|
            n
            s|sha256-[^"]*|'"$hash"'|
        }' "$nix_file"
    fi

    echo "$new_versions" > "$versions_file"
}

platforms=$(jq -r 'keys[]' "$MERGED_FILE")
for platform in $platforms; do
    jq -c ".\"$platform\".hashes" "$MERGED_FILE" > "${platform}-hashes.json"
    jq -c ".\"$platform\".versions" "$MERGED_FILE" > "${platform}-versions.json"
done

update linux_x64 x86_64-linux https://files.ipd.uw.edu/pub/foldit/Foldit-linux_x64.tar.gz "--unpack"
update macos_x64 x86_64-darwin https://files.ipd.uw.edu/pub/foldit/Foldit-macos_x64.dmg ""

merged_json='{}'
for platform in $platforms; do
    merged_json="$(echo "$merged_json" | jq \
        --arg platform "$platform" \
        --argjson versions "$(jq -c . "${platform}-versions.json")" \
        --argjson hashes "$(jq -c . "${platform}-hashes.json")" \
        '.[$platform] = {versions: $versions, hashes: $hashes}')"
done
echo "$merged_json" > "$MERGED_FILE"
for platform in $platforms; do
    rm "${platform}-hashes.json" "${platform}-versions.json"
done

cd "$OLD_PWD"
