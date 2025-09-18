#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq

# Outputs a list of maintainers that would be pinged across two nixpkgs revisions.
# Authors:
#  Morgan Jones (@numinit)
#  Tristan Ross (@RossComputerGuy)

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <rev-from> <rev-to>" >&2
    exit 1
fi

repo="$(git rev-parse --show-toplevel)"
system="$(nix-instantiate --eval --expr builtins.currentSystem)"
rev1="$(git -C "$repo" rev-parse "$1")"
rev2="$(git -C "$repo" rev-parse "$2")"

echo "Touched files:" >&2
git -C "$repo" diff --name-only "$rev1" "$rev2" \
    | jq --raw-input --slurp 'split("\n")[:-1]' | tee "$TMPDIR/touched-files.json" >&2

# Runs an eval in the given worktree, outputting the path to $TMPDIR/$1.path.
# $1: The revision SHA.
eval_in_worktree() (
    mkdir -p .worktree
    local rev="$1"
    local tree=".worktree/$rev"
    if [ ! -d "$tree" ]; then
        git -C "$repo" worktree add -f -d "$tree" "$rev" >&2
    fi
    cd "$tree"

    local workdir="$TMPDIR/$rev"
    rm -rf "$workdir"
    mkdir -p "$workdir"

    nix-build ci -A eval.attrpathsSuperset -o "$workdir/paths" >&2
    mkdir -p "$workdir/intermediates"
    nix-build ci -A eval.singleSystem \
        --arg evalSystem "$system" \
        --arg attrpathFile "$workdir/paths/paths.json" \
        --arg chunkSize ${CHUNK_SIZE:-10000} \
        -o "$workdir/intermediates/.intermediate-1" >&2

    # eval.combine nix-build needs a directory, not a symlink
    cp -RL "$workdir/intermediates/.intermediate-1" "$workdir/intermediates/intermediate-1"
    chmod -R +w "$workdir/intermediates/intermediate-1"
    rm -rf "$workdir/intermediates/.intermediate-1"

    nix-build ci -A eval.combine \
        --arg resultsDir "$workdir/intermediates" \
        -o "$workdir/result" >&2
)

eval_in_worktree "$rev1" &
pid1=$!
eval_in_worktree "$rev2" &
pid2=$!

wait $pid1
wait $pid2

path1="$TMPDIR/$rev1"
path2="$TMPDIR/$rev2"

# Use the repo this script was executed in to get accurate maintainer info
nix-build "$repo/ci" -A eval.compare \
    --arg beforeResultDir "$path1/result" \
    --arg afterResultDir "$path2/result" \
    --arg touchedFilesJson "$TMPDIR/touched-files.json" \
    --arg byName true \
    -o comparison

echo "Pinged maintainers (check $repo/comparison for more details)" >&2
jq < comparison/maintainers.json
