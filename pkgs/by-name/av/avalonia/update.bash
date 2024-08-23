#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p nix-update -p prefetch-npm-deps
#shellcheck shell=bash

set -euo pipefail

package="$UPDATE_NIX_ATTR_PATH"
nix-update "$package"
src=$(nix-build -A "$package".src --no-out-link)
npmDepsFile=$(nix-instantiate --eval -A "$package".npmDepsFile)
(
    echo '['
    for path in \
        src/Avalonia.DesignerSupport/Remote/HtmlTransport/webapp \
        tests/Avalonia.DesignerSupport.Tests/Remote/HtmlTransport/webapp \
        src/Browser/Avalonia.Browser/webapp
    do
        echo '  {'
        echo "    path = \"$path\";"
        echo prefetch-npm-deps "$src/$path/package-lock.json" >&2
        hash=$(prefetch-npm-deps "$src/$path/package-lock.json")
        echo "    hash = \"$hash\";"
        echo '  }'
    done
    echo ']'
) > "$npmDepsFile"
"$(nix-build -A "$package".fetch-deps --no-out-link)"
