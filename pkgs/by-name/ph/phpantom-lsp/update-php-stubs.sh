#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl gnused gnugrep nix-prefetch-github jq

file="./pkgs/by-name/ph/phpantom-lsp/package.nix"

version="$(grep -oP 'version = "\K[\d\.]+' "$file")"
curl -O "https://raw.githubusercontent.com/AJenbo/phpantom_lsp/refs/tags/$version/stubs.lock"
stubsVersion="$(grep -oP 'commit = "\K[^"]+' ./stubs.lock)"
rm stubs.lock

stubsHash="$(
  nix-prefetch-github --rev "$stubsVersion" "JetBrains" "phpstorm-stubs" --json \
    2> /dev/null \
    | jq -r '.hash'
)"

sed -i 's/\(rev = "\)[^"]*/\1'"$stubsVersion"'/' "$file"
sed -i '/stubsSrc/,/}/ s#\(hash = "\)[^"]*#\1'"$stubsHash"'#' "$file"
