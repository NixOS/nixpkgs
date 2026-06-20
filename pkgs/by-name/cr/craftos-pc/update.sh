#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github
set -euo pipefail

package_file="$(dirname "$0")/default.nix"

latest_tag=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/MCJack123/craftos2/releases/latest | jq -e -r ".tag_name")

version="${latest_tag:1}"

function get_old_hash() {
    local reponame="$1"
    # HACK: We assume that the hash we want is within four lines of the first occurrence of reponame
    grep "$reponame = fetchFromGitHub {\$" -A 4 "$package_file" | sed -n 's/.*hash = "\(.*\)".*/\1/p'
}

function get_new_hash() {
    local reponame="$1"
    # We assume that all repositories of interest are owned by MCJack123
    nix-prefetch-github --json --rev "v$version" MCJack123 "$reponame" | jq -r ".hash"
}

old_src_hash="$(get_old_hash src)"
old_lua_hash="$(get_old_hash craftos2-lua)"
old_rom_hash="$(get_old_hash craftos2-rom)"

new_src_hash="$(get_new_hash craftos2)"
new_lua_hash="$(get_new_hash craftos2-lua)"
new_rom_hash="$(get_new_hash craftos2-rom)"

sed -i 's/version = ".*";/version = "'"$version"'";/g' "$package_file"
sed -i "s|$old_src_hash|$new_src_hash|g" "$package_file"
sed -i "s|$old_lua_hash|$new_lua_hash|g" "$package_file"
sed -i "s|$old_rom_hash|$new_rom_hash|g" "$package_file"
