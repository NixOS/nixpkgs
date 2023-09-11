#!/usr/bin/env bash

# Benchmarks lib.fileset
# Run:
# [nixpkgs]$ lib/fileset/benchmark.sh HEAD

set -euo pipefail
shopt -s inherit_errexit dotglob

if (( $# == 0 )); then
    echo "Usage: $0 HEAD"
    echo "Benchmarks the current tree against the HEAD commit. Any git ref will work."
    exit 1
fi
compareTo=$1

SCRIPT_FILE=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "$SCRIPT_FILE")

nixpkgs=$(cd "$SCRIPT_DIR/../.."; pwd)

tmp="$(mktemp -d)"
clean_up() {
    rm -rf "$tmp"
}
trap clean_up EXIT SIGINT SIGTERM
work="$tmp/work"
mkdir "$work"
cd "$work"

# Create a fairly populated tree
touch f{0..5}
mkdir d{0..5}
mkdir e{0..5}
touch d{0..5}/f{0..5}
mkdir -p d{0..5}/d{0..5}
mkdir -p e{0..5}/e{0..5}
touch d{0..5}/d{0..5}/f{0..5}
mkdir -p d{0..5}/d{0..5}/d{0..5}
mkdir -p e{0..5}/e{0..5}/e{0..5}
touch d{0..5}/d{0..5}/d{0..5}/f{0..5}
mkdir -p d{0..5}/d{0..5}/d{0..5}/d{0..5}
mkdir -p e{0..5}/e{0..5}/e{0..5}/e{0..5}
touch d{0..5}/d{0..5}/d{0..5}/d{0..5}/f{0..5}

bench() {
    NIX_PATH=nixpkgs=$1 NIX_SHOW_STATS=1 NIX_SHOW_STATS_PATH=$tmp/stats.json \
        nix-instantiate --eval --strict --show-trace >/dev/null \
        --expr '(import <nixpkgs/lib>).fileset.toSource { root = ./.; fileset = ./.; }'
    cat "$tmp/stats.json"
}

echo "Running benchmark on index" >&2
bench "$nixpkgs" > "$tmp/new.json"
(
    echo "Checking out $compareTo" >&2
    git -C "$nixpkgs" worktree add --quiet "$tmp/worktree" "$compareTo"
    trap 'git -C "$nixpkgs" worktree remove "$tmp/worktree"' EXIT
    echo "Running benchmark on $compareTo" >&2
    bench "$tmp/worktree" > "$tmp/old.json"
)

declare -a stats=(
    ".envs.elements"
    ".envs.number"
    ".gc.totalBytes"
    ".list.concats"
    ".list.elements"
    ".nrFunctionCalls"
    ".nrLookups"
    ".nrOpUpdates"
    ".nrPrimOpCalls"
    ".nrThunks"
    ".sets.elements"
    ".sets.number"
    ".symbols.number"
    ".values.number"
)

different=0
for stat in "${stats[@]}"; do
    oldValue=$(jq "$stat" "$tmp/old.json")
    newValue=$(jq "$stat" "$tmp/new.json")
    if (( oldValue != newValue )); then
        percent=$(bc <<< "scale=100; result = 100/$oldValue*$newValue; scale=4; result / 1")
        if (( oldValue < newValue )); then
            echo -e "Statistic $stat ($newValue) is \e[0;31m$percent% (+$(( newValue - oldValue )))\e[0m of the old value $oldValue" >&2
        else
            echo -e "Statistic $stat ($newValue) is \e[0;32m$percent% (-$(( oldValue - newValue )))\e[0m of the old value $oldValue" >&2
        fi
        (( different++ )) || true
    fi
done
echo "$different stats differ between the current tree and $compareTo"
