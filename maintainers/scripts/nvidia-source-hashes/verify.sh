#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq

# shellcheck shell=bash
# Verify that every source URL fetched by `linuxPackages.nvidiaPackages.*`
# actually serves the content nixpkgs declares a hash for.
#
# Each check downloads a single URL into a freshly salted fixed-output
# derivation, so a stale hash cannot be hidden by an already populated store
# or binary cache.  Every URL of a source is checked separately: a source that
# lists several URLs (GitHub and NVIDIA) is only correct if all of them match.
# This is exactly the case a normal build misses, because it stops at the
# first URL that works.
#
# Intended for a Linux host; can be run from anywhere inside the nixpkgs
# checkout.  Platform specific sources (the binary driver and fabricmanager)
# are evaluated for every supported platform and downloaded with the host's
# fetcher, so `sha256_64bit`, `sha256_32bit` and `sha256_aarch64` are all
# covered.  Use --systems to restrict that.
#
# Usage: verify.sh [options]
#
# Options:
#   -p, --path LIST     Comma-separated substrings a component's path must
#                       contain, e.g. "production" or "passthru.open".
#                       Default: everything.
#   -s, --systems LIST  Comma-separated platforms whose binary driver and
#                       fabricmanager archives are checked, e.g. "x86_64-linux".
#                       Platforms a driver does not support are ignored.
#                       Default: x86_64-linux, i686-linux, aarch64-linux.
#   -l, --list          Only list the checks that would run, then exit.
#   -n, --dry-run       Like --list, but also print each hash.
#   -P, --prefetch      Download every selected URL and print the hash it
#                       actually yields, instead of checking the declared one.
#                       Use this when bumping a version: it prints the hashes
#                       to put into nixpkgs.  The URLs still come from nixpkgs,
#                       and the hash is taken the same way nixpkgs does
#                       (unpacked for the fetchzip sources, after postFetch for
#                       the open kernel modules), so the printed hash is the
#                       one to paste.
#       --strict        Treat a URL that returns 404 as a failure.  By default
#                       such URLs are listed separately and do not fail the
#                       run, because GitHub and NVIDIA publish the same release
#                       at different times, so one of a source's URLs can
#                       legitimately be missing.
#   -h, --help          Show this help.
#
# Examples:
#   # everything (slow: downloads every driver from every URL)
#   ./verify.sh
#
#   # only the sources that gained an NVIDIA URL
#   ./verify.sh --path passthru.open,passthru.modprobe
#
#   # a single driver and only the binary driver archives
#   ./verify.sh --path production
#
#   # only the 32-bit binary driver archives
#   ./verify.sh --path legacy_390 --systems i686-linux
#
#   # print the hashes currently served for one driver (after a version bump)
#   ./verify.sh --prefetch --path beta
#
# A URL that fails is reported and the run continues, so one failure does not
# hide the others.  A URL that returns 404 is listed separately and only fails
# the run with --strict, but a source whose URLs all return 404 always fails,
# since then no host has published it.  A 503, or a 429 from rate limiting,
# counts as a failure.  Exit status is 0 when every selected URL matched its
# declared hash, 1 when at least one did not, and 130 when interrupted with
# Ctrl+C.  In --prefetch mode the status is 0 once every selected URL either
# yielded a hash or returned 404, and 1 if some URL failed for another reason.

set -o errexit -o nounset -o pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
nix_file="$script_dir/default.nix"

path=""
systems=""
mode="run"
strict=""

usage() {
    awk 'NR > 2 && !/^[[:space:]]*$/ { if (/^#/) print; else exit }' "$0" |
        sed -e 's/^# \{0,1\}//' |
        grep -v '^shellcheck ' || true
}

die() {
    echo >&2 "error: $*"
    echo >&2
    usage >&2
    exit 1
}

while (( $# > 0 )); do
    case "$1" in
        -p|--path) path=${2:?"--path requires an argument"}; shift 2 ;;
        -s|--systems) systems=${2:?"--systems requires an argument"}; shift 2 ;;
        -l|--list) mode=list; shift ;;
        -n|--dry-run) mode=dry-run; shift ;;
        -P|--prefetch) mode=prefetch; shift ;;
        --strict) strict=1; shift ;;
        -h|--help) usage; exit 0 ;;
        --) shift; break ;;
        -*) die "unknown option '$1'" ;;
        *) die "unexpected argument '$1'" ;;
    esac
done

tmp=$(mktemp -d)
cleanup() {
    set +o errexit
    rm -rf "$tmp"
}
trap cleanup EXIT

# A single Ctrl+C stops the run.  Without this, the signal also reaches the
# nix-store build, whose death looks like a failed check and lets the loop
# continue with the next URL.
interrupted() {
    printf '\nInterrupted.\n' >&2
    exit 130
}
trap interrupted INT

# A source whose URLs all return 404 is a failure in both modes.  One missing
# URL can be a host that has not published a release yet; when every URL is
# missing, no host has it.
dead_components() {
    local keys=("$@")
    local comp
    local here all
    for comp in $(printf '%s\n' "${keys[@]}" | sed 's/-u[0-9]*$//' | sort -u); do
        here=$(printf '%s\n' "${keys[@]}" | sed 's/-u[0-9]*$//' | grep -cx -- "$comp")
        all=$(jq -r --arg prefix "$comp-" '[keys[] | select(startswith($prefix))] | length' "$tmp/meta.json")
        if [[ "$here" == "$all" ]]; then
            printf '%s\n' "$comp"
        fi
    done
}

# Both helpers take the same arguments; `pkgs` is left to default.nix so that
# this repository's nixpkgs is always the one being inspected.
cat > "$tmp/meta.nix" <<'EOF'
{ nixFile, systems ? "", path ? "", prefetch ? false }:
let
  tests = import nixFile { inherit systems path prefetch; };
in
builtins.mapAttrs (key: drv: {
  inherit key;
  name = drv.name;
  drvPath = drv.drvPath;
  hash = drv.hash or "";
  urls = drv.urls or [ ];
}) tests
EOF

cat > "$tmp/drvs.nix" <<'EOF'
{ nixFile, systems ? "", path ? "", prefetch ? false }:
import nixFile { inherit systems path prefetch; }
EOF

if [[ "$mode" == prefetch ]]; then
    prefetch_arg=true
else
    prefetch_arg=false
fi

filter_args=(
    --argstr nixFile "$nix_file"
    --argstr systems "$systems"
    --argstr path "$path"
    --arg prefetch "$prefetch_arg"
)

echo >&2 "Evaluating linuxPackages.nvidiaPackages sources.."
nix-instantiate --eval --strict --json "${filter_args[@]}" "$tmp/meta.nix" > "$tmp/meta.json"

total=$(jq 'length' "$tmp/meta.json")
if (( total == 0 )); then
    echo "No source URL matched the given filters." >&2
    exit 0
fi

case "$mode" in
    list|dry-run)
        if [[ "$mode" == dry-run ]]; then
            jq -r 'to_entries[] | "\(.key)\n    url:  \(.value.urls[0])\n    hash: \(.value.hash)"' "$tmp/meta.json"
        else
            jq -r 'to_entries[] | "\(.key)\n    \(.value.urls[0])"' "$tmp/meta.json"
        fi
        echo "$total check(s) selected." >&2
        exit 0
        ;;
esac

# Instantiate once so every derivation is on disk, then realise each one
# individually to get per-URL results without re-evaluating nixpkgs.
if ! nix-instantiate "${filter_args[@]}" "$tmp/drvs.nix" > /dev/null 2> "$tmp/instantiate.err"; then
    echo >&2 "error: failed to instantiate the selected derivations:"
    cat >&2 "$tmp/instantiate.err"
    exit 1
fi

if [[ "$mode" == prefetch ]]; then
    ok=0
    bad=0
    unavailable=0
    unavailable_keys=()
    while IFS=$'\t' read -r key drv_path url; do
        log="$tmp/log"
        if nix-store --realise "$drv_path" > /dev/null 2> "$log"; then
            bad=$((bad + 1))
            printf '%s\n    %s\n    ERROR: unexpectedly matched the bogus hash\n' "$key" "$url" >&2
            continue
        fi
        got=$(sed -n 's/^ *got: *//p' "$log" | head -n 1)
        if [[ -n "$got" ]]; then
            ok=$((ok + 1))
            printf '%s\n    %s\n    -> %s\n' "$key" "$url" "$got"
        elif grep -qE "returned error: 404" "$log"; then
            unavailable=$((unavailable + 1))
            unavailable_keys+=("$key")
            printf '%s\n    %s\n    URL NOT AVAILABLE\n' "$key" "$url" >&2
        else
            bad=$((bad + 1))
            printf '%s\n    %s\n    ERROR\n' "$key" "$url" >&2
            grep -E "curl:|error:" "$log" | head -n 3 | sed 's/^ */    /' >&2 || true
        fi
    done < <(jq -r 'to_entries[] | [.key, .value.drvPath, (.value.urls[0] // "")] | @tsv' "$tmp/meta.json")
    declare -a dead=()
    if (( unavailable > 0 )); then
        mapfile -t dead < <(dead_components "${unavailable_keys[@]}")
    fi

    printf '\n%d hash(es) obtained' "$ok"
    if (( unavailable > 0 )); then
        printf ', %d URL(s) not published: %s' "$unavailable" "${unavailable_keys[*]}"
    fi
    if (( ${#dead[@]} > 0 )); then
        printf ', no URL published for: %s' "${dead[*]}"
    fi
    if (( bad > 0 )); then
        printf ', %d failed\n' "$bad"
        exit 1
    fi
    printf '.\n'
    if (( strict && unavailable > 0 )) || (( ${#dead[@]} > 0 )); then
        exit 1
    fi
    exit 0
fi

pass=0
fail=0
unavailable=0
declare -a failures=()
declare -a unavailable_keys=()
n=0

while IFS=$'\t' read -r key drv_path hash url; do
    n=$((n + 1))
    printf '\n[%d/%d] %s\n    %s\n' "$n" "$total" "$key" "$url"

    log="$tmp/log"
    if nix-store --realise "$drv_path" > /dev/null 2> "$log"; then
        pass=$((pass + 1))
        printf '    hash ok: %s\n' "$hash"
        continue
    fi

    if grep -q "hash mismatch in fixed-output derivation" "$log"; then
        fail=$((fail + 1))
        failures+=("$key")
        printf '    \033[31mHASH MISMATCH\033[0m\n'
        printf '    expected: %s\n' "$hash"
        sed -n 's/^ *got: */    got:      /p' "$log"
    elif grep -qE "returned error: 404" "$log"; then
        unavailable=$((unavailable + 1))
        unavailable_keys+=("$key")
        printf '    \033[33mURL NOT AVAILABLE\033[0m\n'
        grep -E "returned error: 404" "$log" | sed 's/^ */    /'
    else
        fail=$((fail + 1))
        failures+=("$key")
        printf '    \033[31mFAILED\033[0m\n'
        grep -E "curl:|error:" "$log" | head -n 3 | sed 's/^ */    /' || true
    fi
done < <(jq -r 'to_entries[] | [.key, .value.drvPath, .value.hash, (.value.urls[0] // "")] | @tsv' "$tmp/meta.json")

declare -a dead=()
if (( unavailable > 0 )); then
    mapfile -t dead < <(dead_components "${unavailable_keys[@]}")
fi

printf '\n%d/%d URL(s) matched their declared hash' "$pass" "$total"
if (( unavailable > 0 )); then
    printf ', %d URL(s) not published: %s' "$unavailable" "${unavailable_keys[*]}"
fi
if (( ${#dead[@]} > 0 )); then
    printf ', no URL published for: %s' "${dead[*]}"
fi
if (( fail > 0 )); then
    printf ', %d failed: %s' "$fail" "${failures[*]}"
fi
printf '.\n'
if (( unavailable > 0 && !strict && ${#dead[@]} == 0 )); then
    echo >&2 "A URL that returns 404 is not a hash mismatch; pass --strict to fail on it."
fi
if (( fail > 0 || ${#dead[@]} > 0 || (strict && unavailable > 0) )); then
    exit 1
fi
