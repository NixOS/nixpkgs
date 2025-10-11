#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

REQUEST_URL=https://fold.it/api/get_update_components
MERGED_FILE="hot-updates.json"

archiveUrl() {
    url=$1
    res_headers=$(curl -s -D - -o /dev/null "https://web.archive.org/save/$url")
    location=$(printf "%s" "$res_headers" | awk 'BEGIN{IGNORECASE=1}/^Content-Location:/ {print $2}' | tr -d '\r\n')
    if [ -n "$location" ] && echo "$location" | grep -q '^/web/'; then
        echo "https://web.archive.org$location"
        return 0
    fi
    redirect=$(printf "%s" "$res_headers" | awk 'BEGIN{IGNORECASE=1}/^Location:/ {print $2}' | tr -d '\r\n')
    if [ -n "$redirect" ] && echo "$redirect" | grep -q '/web/'; then
        echo "$redirect"
        return 0
    fi
    return 1
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
    while read -r name version download; do
        if [ "$(jq -r '.components["'$name'"].version' "$versions_file")" = "$version" ]; then
            output="$(echo "$output" | jq --arg name "$name" --arg hash "$(jq -r '.["'$name'"]' "$hashes_file")" '.[$name] = $hash')"
            continue
        fi
        hash=$(nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url "$download"))
        output="$(echo "$output" | jq --arg name "$name" --arg hash "$hash" '.[$name] = $hash')"
    done < <(echo $new_versions | jq -r '.components | to_entries[] | "\(.key) \(.value.version) \(.value.download)"')
    echo "$output" > "$hashes_file"

    if [ "$(jq -r '.release_id' "$versions_file")" != "$(echo "$new_versions" | jq -r '.release_id')" ]; then
        url=$(archiveUrl "$original_url")
        hash=$(nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url $prefetch_args "$url"))
        sed -i -E '/'"$(printf '%s\n' "$original_url" | sed 's/[\/&]/\\&/g')"'/ {
            s|^( *url = ")https://[^"]*";|\1'"$url"'";|
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

