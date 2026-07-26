#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix xxd coreutils
# shellcheck shell=bash
#
# Updates the piper-tts voice corpus:
#   - bumps the pinned `rev` in default.nix to the latest commit on
#     rhasspy/piper-voices (HF "main" branch)
#   - refreshes voices.json from that rev
#   - refreshes file-hashes.json
#
# file-hashes.json maps each referenced path to:
#   { "sha256": "sha256-<sri>", "gitOid": "<git blob sha1>" }
# `sha256` is what default.nix's fetchurl actually uses. `gitOid` is a
# cheap content fingerprint (HF's tree API returns it for every entry,
# LFS or not) used purely so this script can tell whether a file's
# content changed across a rev bump *without* downloading it:
#
#   - LFS-tracked files (the big .onnx weights) report their content
#     sha256 directly as `lfs.oid` in the tree API, so we never need
#     to download those to know their hash, changed or not.
#   - Non-LFS files (.onnx.json configs, MODEL_CARD, etc.) are NOT
#     sha256-addressed by HF, so the only way to get their real
#     content hash is to download+hash them -- but only when they've
#     actually changed. We detect that cheaply by comparing the git
#     blob oid recorded last time against the current one; if it's
#     identical, the sha256 we already have on file is still correct
#     and we skip the download entirely.
#
# Why this matters: a path being *present* in the previous
# file-hashes.json does NOT mean its content is unchanged across a
# rev bump -- voices do get re-uploaded/fixed in place upstream.
#
# default.nix, voices.json, and file-hashes.json must always move
# together: writing them out of order (or partially, if a fetch fails
# mid-run) leaves the tree pointing at a rev whose files don't have
# hashes yet. So every fallible step below writes to a scratch copy;
# the three real files are only replaced right at the end, after
# everything has succeeded.
#
# Implements the "commit" supportedFeatures contract: on success prints
# a JSON array describing what changed, so `update.nix --arg commit true`
# can create a commit for it.
set -euo pipefail

cd "$(dirname "$0")"

repo="rhasspy/piper-voices"
api="https://huggingface.co/api/models/${repo}"
parallelism="${UPDATE_PIPER_VOICES_JOBS:-8}"

old_rev=$(grep -oP 'rev = "\K[a-f0-9]+' default.nix | head -1)
new_rev=$(curl -sfL "$api" | jq -r '.sha')

if [[ -z "$new_rev" || "$new_rev" == "null" ]]; then
    echo "Failed to resolve latest revision for ${repo}" >&2
    exit 1
fi

if [[ "$new_rev" == "$old_rev" ]]; then
    echo "[]"
    exit 0
fi

echo "piper-voices: ${old_rev} -> ${new_rev}" >&2

if [[ ! -f file-hashes.json ]]; then
    echo "{}" >file-hashes.json
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/results"

curl -sfL "https://huggingface.co/${repo}/resolve/${new_rev}/voices.json" -o "$work/voices.json"

jq -r '[.[] | .files | keys[]] | unique[]' "$work/voices.json" | sort -u >"$work/paths.txt"
total_paths=$(wc -l <"$work/paths.txt")

# --- fetch the full recursive tree, following cursor pagination ---
echo "  listing ${total_paths} referenced path(s) against upstream tree..." >&2
tree_url="https://huggingface.co/api/models/${repo}/tree/${new_rev}?recursive=true"
: >"$work/tree.jsonl"
page=0
while [[ -n "$tree_url" ]]; do
    page=$((page + 1))
    headers="$work/headers-$page.txt"
    curl -sfL -D "$headers" "$tree_url" | jq -c '.[]' >>"$work/tree.jsonl"
    tree_url=$(grep -i '^link:' "$headers" | grep -oP '<\K[^>]+(?=>;\s*rel="next")' || true)
done

# restrict to referenced paths only, and emit: path, git blob oid, lfs sha256 (or empty)
jq -r -s --slurpfile refs <(jq -R -s -c 'split("\n")[:-1]' "$work/paths.txt") '
  .[]
  | select(.path as $p | $refs[0] | index($p))
  | [.path, .oid, (.lfs.oid // "")]
  | @tsv
' "$work/tree.jsonl" >"$work/tree-referenced.tsv"

found_count=$(wc -l <"$work/tree-referenced.tsv")
if [[ "$found_count" -ne "$total_paths" ]]; then
    echo "WARNING: ${total_paths} paths referenced by voices.json but only ${found_count} found in upstream tree" >&2
fi

declare -A tree_oid tree_lfsoid
while IFS=$'\t' read -r p oid lfsoid; do
    tree_oid["$p"]="$oid"
    tree_lfsoid["$p"]="$lfsoid"
done <"$work/tree-referenced.tsv"

# load existing file-hashes.json
jq -r '
  to_entries[]
  | [.key,
     (.value.sha256 // ""),
     (.value.gitOid // "")]
  | @tsv
' file-hashes.json >"$work/old-hashes.tsv"

declare -A old_sha old_gitoid
while IFS=$'\t' read -r p sha gitoid; do
    old_sha["$p"]="$sha"
    old_gitoid["$p"]="$gitoid"
done <"$work/old-hashes.tsv"

hex_to_sri() {
    # sha256 hex -> "sha256-<base64>"
    printf 'sha256-%s' "$(echo -n "$1" | xxd -r -p | base64 -w0)"
}

: >"$work/new-hashes.tsv" # path <tab> sha256-sri <tab> gitOid
: >"$work/changed.txt"
: >"$work/added.txt"
: >"$work/to-fetch.txt" # non-LFS paths that actually need downloading

n_lfs=0
n_cached=0
while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    oid="${tree_oid[$path]:-}"
    lfsoid="${tree_lfsoid[$path]:-}"

    if [[ -n "$lfsoid" ]]; then
        n_lfs=$((n_lfs + 1))
        sri=$(hex_to_sri "$lfsoid")
        printf '%s\t%s\t%s\n' "$path" "$sri" "$oid" >>"$work/new-hashes.tsv"
        if [[ -z "${old_sha[$path]:-}" ]]; then
            echo "$path" >>"$work/added.txt"
        elif [[ "${old_sha[$path]}" != "$sri" ]]; then
            echo "$path" >>"$work/changed.txt"
        fi
    elif [[ -n "${old_gitoid[$path]:-}" && "${old_gitoid[$path]}" == "$oid" && -n "${old_sha[$path]:-}" ]]; then
        # non-LFS, but git blob oid matches what we saw last time:
        # content is unchanged, reuse the cached hash, no download.
        n_cached=$((n_cached + 1))
        printf '%s\t%s\t%s\n' "$path" "${old_sha[$path]}" "$oid" >>"$work/new-hashes.tsv"
    else
        echo "$path" >>"$work/to-fetch.txt"
    fi
done <"$work/paths.txt"

echo "  ${n_lfs} file(s) resolved via LFS oid, no download needed" >&2
echo "  ${n_cached} non-LFS file(s) unchanged (git oid match), skipping download" >&2

if [[ -s "$work/to-fetch.txt" ]]; then
    n_fetch=$(wc -l <"$work/to-fetch.txt")
    echo "  fetching ${n_fetch} new/changed non-LFS file(s), ${parallelism} at a time..." >&2
    sanitize_store_name() {
        # Nix store path names only allow [A-Za-z0-9+._?=-]; this has
        # nothing to do with what encoding the URL or content uses --
        # the fetch itself stays full UTF-8. We just need a legal local
        # name, the same way Nix's own fetchurl builder auto-sanitizes.
        local base
        base=$(basename "$1")
        base=$(printf '%s' "$base" | LC_ALL=C sed -E 's/[^A-Za-z0-9+_.?=-]/-/g')
        base="${base#.}"
        [[ -z "$base" ]] && base="file"
        printf '%s' "$base"
    }
    fetch_one() {
        set -euo pipefail
        local path="$1" work="$2" repo="$3" new_rev="$4" oid="$5"
        local url="https://huggingface.co/${repo}/resolve/${new_rev}/${path}"
        local store_name
        store_name=$(sanitize_store_name "$path")
        local base32 sri
        # force a UTF-8 locale: nix-prefetch-url has been observed to
        # mis-encode URLs containing non-ASCII path segments (e.g. "ã")
        # under LANG=C, silently returning no hash instead of erroring.
        if ! base32=$(LC_ALL=C.UTF-8 LANG=C.UTF-8 nix-prefetch-url --type sha256 --name "$store_name" "$url" 2>&1 | tail -1); then
            echo "ERROR: failed to fetch ${url}: ${base32}" >&2
            return 1
        fi
        if [[ ! "$base32" =~ ^[0-9a-z]{52}$ ]]; then
            echo "ERROR: nix-prefetch-url returned a malformed hash for ${url}: '${base32}'" >&2
            return 1
        fi
        sri=$(nix hash convert --hash-algo sha256 --to sri "$base32")
        printf '%s\t%s\t%s\n' "$path" "$sri" "$oid" >"$work/results/$(echo "$path" | tr '/' '_').tsv"
        echo "  [fetched] ${path}" >&2
    }
    export -f fetch_one sanitize_store_name
    export work repo new_rev
    if ! while IFS= read -r path; do
        printf '%s\t%s\n' "$path" "${tree_oid[$path]:-}"
    done <"$work/to-fetch.txt" | xargs -P "$parallelism" -I{} bash -c '
        line="{}"
        path="${line%%$'"'"'\t'"'"'*}"
        oid="${line#*$'"'"'\t'"'"'}"
        fetch_one "$path" "$work" "$repo" "$new_rev" "$oid"
    '; then
        echo "ERROR: one or more voice file fetches failed, aborting" >&2
        exit 1
    fi
    shopt -s nullglob
    for f in "$work/results"/*.tsv; do
        cat "$f" >>"$work/new-hashes.tsv"
        path=$(cut -f1 "$f")
        sri=$(cut -f2 "$f")
        if [[ -z "${old_sha[$path]:-}" ]]; then
            echo "$path" >>"$work/added.txt"
        elif [[ "${old_sha[$path]}" != "$sri" ]]; then
            echo "$path" >>"$work/changed.txt"
        fi
    done
    shopt -u nullglob
fi

# final safety net: refuse to write file-hashes.json if any entry has an
# empty or malformed sha256 -- better a loud failure here than a silent
# lib.fakeHash baked into the committed file
if awk -F'\t' 'NF < 3 || $2 !~ /^sha256-.+/ { print; bad=1 } END { exit bad }' "$work/new-hashes.tsv"; then
    :
else
    echo "ERROR: one or more entries in new-hashes.tsv have missing/malformed hashes (see above), aborting" >&2
    exit 1
fi

# build the final file-hashes.json, restricted to currently-referenced paths
jq -R -s -c '
  split("\n")[:-1]
  | map(split("\t"))
  | map({(.[0]): {sha256: .[1], gitOid: .[2]}})
  | add // {}
' "$work/new-hashes.tsv" | jq -S . >"$work/file-hashes.json"

# --- report which voices were affected (not just which files) ---
touch "$work/changed.txt" "$work/added.txt"
cat "$work/changed.txt" "$work/added.txt" | sort -u >"$work/touched-paths.txt"
if [[ -s "$work/touched-paths.txt" ]]; then
    voices_touched=$(jq -r --slurpfile touched <(jq -R -s -c 'split("\n")[:-1]' "$work/touched-paths.txt") '
        to_entries
        | map(select(.value.files | keys | any(. as $f | $touched[0] | index($f))))
        | map(.key)
        | sort
        | .[]
    ' "$work/voices.json")
    n_changed=$(wc -l <"$work/changed.txt")
    n_added=$(wc -l <"$work/added.txt")
    echo "  ${n_changed} file(s) changed, ${n_added} file(s) newly added" >&2
    echo "  voices affected:" >&2
    echo "$voices_touched" | sed 's/^/    /' >&2
else
    echo "  no voice file content actually changed for this rev bump" >&2
fi

# Everything succeeded — commit the three files together, atomically
# from the caller's perspective.
sed -i "s|rev = \"${old_rev}\";|rev = \"${new_rev}\";|" default.nix
if ! grep -qF "rev = \"${new_rev}\";" default.nix; then
    echo "ERROR: failed to update rev in default.nix (old_rev '${old_rev}' not found?)" >&2
    exit 1
fi
mv "$work/voices.json" voices.json
mv "$work/file-hashes.json" file-hashes.json

jq -n \
    --arg attrPath "piperTtsVoices" \
    --arg oldVersion "$old_rev" \
    --arg newVersion "$new_rev" \
    --arg f1 "$(pwd)/default.nix" \
    --arg f2 "$(pwd)/voices.json" \
    --arg f3 "$(pwd)/file-hashes.json" \
    '[{attrPath: $attrPath, oldVersion: $oldVersion, newVersion: $newVersion, files: [$f1, $f2, $f3]}]'
