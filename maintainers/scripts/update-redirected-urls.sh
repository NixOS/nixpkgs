#! /usr/bin/env nix-shell
#! nix-shell -p bash curl ripgrep jq -i bash
# shellcheck shell=bash

set -euxo pipefail

# Possibly also add non-https redirect, but there were non of those when I first
# made this script to test that. Feel free to add it when it is relevant.
curl https://repology.org/api/v1/repository/nix_unstable/problems \
   | jq -r '.[] | select(.type == "homepage_permanent_https_redirect") | .data | "s@\(.url)@\(.target)@"' \
   | sort | uniq | tee script.sed
find -name '*.nix' | xargs -P4 -- sed -f script.sed -i
rm script.sed
