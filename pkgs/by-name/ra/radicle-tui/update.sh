#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnused gitMinimal nix-update

set -euo pipefail

dirname="$(dirname "${BASH_SOURCE[0]}")"

url=$(nix-instantiate --eval --raw -A radicle-tui.src.url)
old_node=$(nix-instantiate --eval --raw -A radicle-tui.src.node)

ref=$(git ls-remote "$url" 'refs/namespaces/*/refs/tags/*' | cut -f2 | tail -1)
[[ "$ref" =~ ^refs/namespaces/([^/]+)/refs/tags/([^/]+)$ ]]
new_node="${BASH_REMATCH[1]}"
version="${BASH_REMATCH[2]}"

sed -i "s/${old_node}/${new_node}/g" "${dirname}/package.nix"
nix-update --version="$version" radicle-tui
