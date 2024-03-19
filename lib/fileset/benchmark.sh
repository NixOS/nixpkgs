#!/usr/bin/env nix-shell
#!nix-shell -i bash -p sta jq bc nix -I nixpkgs=../..
# shellcheck disable=SC2016

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

runs=10

run() {
    # Empty the file
    : > cpuTimes

    for i in $(seq 0 "$runs"); do
        NIX_PATH=nixpkgs=$1 NIX_SHOW_STATS=1 NIX_SHOW_STATS_PATH=$tmp/stats.json \
            nix-instantiate --eval --strict --show-trace >/dev/null \
            --expr 'with import <nixpkgs/lib>; with fileset; '"$2"

        # Only measure the time after the first run, one is warmup
        if (( i > 0 )); then
            jq '.cpuTime' "$tmp/stats.json" >> cpuTimes
        fi
    done

    # Compute mean and standard deviation
    read -r mean sd < <(sta --mean --sd --brief <cpuTimes)

    jq --argjson mean "$mean" --argjson sd "$sd" \
        '.cpuTimeMean = $mean | .cpuTimeSd = $sd' \
        "$tmp/stats.json"
}

bench() {
    echo "Benchmarking expression $1" >&2
    #echo "Running benchmark on index" >&2
    run "$nixpkgs" "$1" > "$tmp/new.json"
    (
        #echo "Checking out $compareTo" >&2
        git -C "$nixpkgs" worktree add --quiet "$tmp/worktree" "$compareTo"
        trap 'git -C "$nixpkgs" worktree remove "$tmp/worktree"' EXIT
        #echo "Running benchmark on $compareTo" >&2
        run "$tmp/worktree" "$1" > "$tmp/old.json"
    )

    read -r oldMean oldSd newMean newSd percentageMean percentageSd < \
        <(jq -rn --slurpfile old "$tmp/old.json" --slurpfile new "$tmp/new.json" \
        ' $old[0].cpuTimeMean as $om
        | $old[0].cpuTimeSd as $os
        | $new[0].cpuTimeMean as $nm
        | $new[0].cpuTimeSd as $ns
        | (100 / $om * $nm) as $pm
        # Copied from https://github.com/sharkdp/hyperfine/blob/b38d550b89b1dab85139eada01c91a60798db9cc/src/benchmark/relative_speed.rs#L46-L53
        | ($pm * pow(pow($ns / $nm; 2) + pow($os / $om; 2); 0.5)) as $ps
        | [ $om, $os, $nm, $ns, $pm, $ps ]
        | @sh')

    echo -e "Mean CPU time $newMean (σ = $newSd) for $runs runs is \e[0;33m$percentageMean% (σ = $percentageSd%)\e[0m of the old value $oldMean (σ = $oldSd)" >&2

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
    echo ""
}

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

bench 'toSource { root = ./.; fileset = ./.; }'

rm -rf -- *

touch {0..1000}
bench 'toSource { root = ./.; fileset = unions (mapAttrsToList (name: value: ./. + "/${name}") (builtins.readDir ./.)); }'
rm -rf -- *
