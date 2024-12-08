#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl jq nix-prefetch-github

set -euo pipefail

latest_version=$(curl -s https://api.github.com/repos/Gnucash/gnucash/releases/latest | jq -r '.tag_name')

if [[ "$latest_version" = "$UPDATE_NIX_OLD_VERSION" ]]; then
    echo "already up to date"
    exit 0
fi

old_src_hash=$(nix-instantiate --eval -A gnucash.src.outputHash | tr -d '"')
old_src_doc_hash=$(nix-instantiate --eval -A gnucash.docs.src.outputHash | tr -d '"')

src_hash=$(nix-prefetch-url "https://github.com/Gnucash/gnucash/releases/download/$latest_version/gnucash-$latest_version.tar.bz2")
src_hash=$(nix-hash --to-sri --type sha256 "$src_hash")
src_doc_hash=$(nix-prefetch-github Gnucash gnucash-docs --rev "$latest_version" | jq -r .hash)
src_doc_hash=$(nix-hash --to-sri --type sha256 "$src_doc_hash")

cd "$(dirname "${BASH_SOURCE[0]}")"
sed -i default.nix -e "s|$old_src_hash|$src_hash|"
sed -i default.nix -e "s|$old_src_doc_hash|$src_doc_hash|"
sed -i default.nix -e "/ version =/s|\"${UPDATE_NIX_OLD_VERSION}\"|\"${latest_version}\"|"
