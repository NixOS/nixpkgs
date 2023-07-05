#!/usr/bin/env bash

# Property tests for the `lib.path` library
#
# It generates random path-like strings and runs the functions on
# them, checking that the expected laws of the functions hold

set -euo pipefail
shopt -s inherit_errexit

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if test -z "${TEST_LIB:-}"; then
    TEST_LIB=$SCRIPT_DIR/../..
fi

tmp="$(mktemp -d)"
clean_up() {
    rm -rf "$tmp"
}
trap clean_up EXIT
mkdir -p "$tmp/work"
cd "$tmp/work"

# Defaulting to a random seed but the first argument can override this
seed=${1:-$RANDOM}
echo >&2 "Using seed $seed, use \`lib/path/tests/prop.sh $seed\` to reproduce this result"

# The number of random paths to generate. This specific number was chosen to
# be fast enough while still generating enough variety to detect bugs.
count=500

debug=0
# debug=1 # print some extra info
# debug=2 # print generated values

# Fine tuning parameters to balance the number of generated invalid paths
# to the variance in generated paths.
extradotweight=64   # Larger value: more dots
extraslashweight=64 # Larger value: more slashes
extranullweight=16  # Larger value: shorter strings

die() {
    echo >&2 "test case failed: " "$@"
    exit 1
}

if [[ "$debug" -ge 1 ]]; then
    echo >&2 "Generating $count random path-like strings"
fi

# Read stream of null-terminated strings entry-by-entry into bash,
# write it to a file and the `strings` array.
declare -a strings=()
mkdir -p "$tmp/strings"
while IFS= read -r -d $'\0' str; do
    printf "%s" "$str" > "$tmp/strings/${#strings[@]}"
    strings+=("$str")
done < <(awk \
    -f "$SCRIPT_DIR"/generate.awk \
    -v seed="$seed" \
    -v count="$count" \
    -v extradotweight="$extradotweight" \
    -v extraslashweight="$extraslashweight" \
    -v extranullweight="$extranullweight")

if [[ "$debug" -ge 1 ]]; then
    echo >&2 "Trying to normalise the generated path-like strings with Nix"
fi

# Precalculate all normalisations with a single Nix call. Calling Nix for each
# string individually would take way too long
nix-instantiate --eval --strict --json --show-trace \
    --argstr libpath "$TEST_LIB" \
    --argstr dir "$tmp/strings" \
    "$SCRIPT_DIR"/prop.nix \
    >"$tmp/result.json"

# Uses some jq magic to turn the resulting attribute set into an associative
# bash array assignment
declare -A normalised_result="($(jq '
    to_entries
    | map("[\(.key | @sh)]=\(.value | @sh)")
    | join(" \n")' -r < "$tmp/result.json"))"

# Looks up a normalisation result for a string
# Checks that the normalisation is only failing iff it's an invalid subpath
# For valid subpaths, returns 0 and prints the normalisation result
# For invalid subpaths, returns 1
normalise() {
    local str=$1
    # Uses the same check for validity as in the library implementation
    if [[ "$str" == "" || "$str" == /* || "$str" =~ ^(.*/)?\.\.(/.*)?$ ]]; then
        valid=
    else
        valid=1
    fi

    normalised=${normalised_result[$str]}
    # An empty string indicates failure, this is encoded in ./prop.nix
    if [[ -n "$normalised" ]]; then
        if [[ -n "$valid" ]]; then
            echo "$normalised"
        else
            die "For invalid subpath \"$str\", lib.path.subpath.normalise returned this result: \"$normalised\""
        fi
    else
        if [[ -n "$valid" ]]; then
            die "For valid subpath \"$str\", lib.path.subpath.normalise failed"
        else
            if [[ "$debug" -ge 2 ]]; then
                echo >&2 "String \"$str\" is not a valid subpath"
            fi
            # Invalid and it correctly failed, we let the caller continue if they catch the exit code
            return 1
        fi
    fi
}

# Intermediate result populated by test_idempotency_realpath
# and used in test_normalise_uniqueness
#
# Contains a mapping from a normalised subpath to the realpath result it represents
declare -A norm_to_real

test_idempotency_realpath() {
    if [[ "$debug" -ge 1 ]]; then
        echo >&2 "Checking idempotency of each result and making sure the realpath result isn't changed"
    fi

    # Count invalid subpaths to display stats
    invalid=0
    for str in "${strings[@]}"; do
        if ! result=$(normalise "$str"); then
            ((invalid++)) || true
            continue
        fi

        # Check the law that it doesn't change the result of a realpath
        mkdir -p -- "$str" "$result"
        real_orig=$(realpath -- "$str")
        real_norm=$(realpath -- "$result")

        if [[ "$real_orig" != "$real_norm" ]]; then
            die "realpath of the original string \"$str\" (\"$real_orig\") is not the same as realpath of the normalisation \"$result\" (\"$real_norm\")"
        fi

        if [[ "$debug" -ge 2 ]]; then
            echo >&2 "String \"$str\" gets normalised to \"$result\" and file path \"$real_orig\""
        fi
        norm_to_real["$result"]="$real_orig"
    done
    if [[ "$debug" -ge 1 ]]; then
        echo >&2 "$(bc <<< "scale=1; 100 / $count * $invalid")% of the total $count generated strings were invalid subpath strings, and were therefore ignored"
    fi
}

test_normalise_uniqueness() {
    if [[ "$debug" -ge 1 ]]; then
        echo >&2 "Checking for the uniqueness law"
    fi

    for norm_p in "${!norm_to_real[@]}"; do
        real_p=${norm_to_real["$norm_p"]}
        for norm_q in "${!norm_to_real[@]}"; do
            real_q=${norm_to_real["$norm_q"]}
            # Checks normalisation uniqueness law for each pair of values
            if [[ "$norm_p" != "$norm_q" && "$real_p" == "$real_q" ]]; then
                die "Normalisations \"$norm_p\" and \"$norm_q\" are different, but the realpath of them is the same: \"$real_p\""
            fi
        done
    done
}

test_idempotency_realpath
test_normalise_uniqueness

echo >&2 tests ok
