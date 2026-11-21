#! /usr/bin/env nix-shell
#! nix-shell -p racket-minimal nix-prefetch-git nix-prefetch-github jq
#! nix-shell -i bash

set -eu -o pipefail
dir="$(dirname "$0")"
cd "$dir"

declare -a rkt_args
if test -v 1; then
    rkt_args=("$@")
else
    rkt_args=("-c" "-o" "$(realpath main-distribution.json)" "-r" "$(jq --raw-output ".version" ../manifest.json)" "main-distribution")
fi

echo "generating manifest with arguments: ${rkt_args[@]}"

racket -W warning -u specify-packages.rkt "${rkt_args[@]}"

echo "manifest successfully generated"
