#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash sd curl git nix nix-update perl

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
nix_file="$nixpkgs/pkgs/by-name/la/lark-cli/package.nix"

nix-update lark-cli

# if not changed, exit
if git diff --quiet -- "$nix_file"; then
    exit 0
fi

# Update the url and hash
version=$(nix eval --raw .#lark-cli.version)
target_url="https://open.feishu.cn/api/tools/open/api_definition?protocol=meta&client_version=v${version}"

archived_url=$(curl -s -I -L -o /dev/null "https://web.archive.org/save/${target_url}" -w '%{url_effective}')

new_ts=$(echo "$archived_url" | sd '.*web/([0-9]{14}).*' '$1')
new_hash=$(nix-prefetch-url --type sha256 "$archived_url" | xargs nix hash convert --hash-algo sha256 --to sri)

sd 'web\.archive\.org/web/[0-9]{14}' 'web.archive.org/web/'"$new_ts" "$nix_file"
perl -0777 -i -pe 's|(metaDataRaw = fetchurl \{.*?hash = )"[^"]*"|$1"'"$new_hash"'"|s' "$nix_file"


# Update date
new_date=$(date +%Y-%m-%d)
sd "Date=[0-9]{4}-[0-9]{2}-[0-9]{2}" "Date=$new_date" "$nix_file"
