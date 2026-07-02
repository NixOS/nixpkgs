#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pcre common-updater-scripts

set -eu -o pipefail

# Expect the text in format of '<a href="official/postfix-3.7.4.tar.gz">Source code</a> |'
# Stable release goes first.
new_version="$(curl -s https://postfix-mirror.horus-it.com/postfix-release/index.html |
    pcregrep -o1 '"official/postfix-([0-9.]+)[.]tar[.]gz">' | head -n1)"
update-source-version postfix "$new_version"
