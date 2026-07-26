#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix
# shellcheck shell=bash
#
# Updates two independent upstream pins, one per file:
#   - default.nix:                     rhasspy/piper-checkpoints (dataset) -> zh/zh_CN/_resources/g2pw.tar.gz
#   - bert-base-chinese-tokenizer.nix: google-bert/bert-base-chinese        -> config.json / vocab.txt / tokenizer_config.json
#
# Each is checked and updated independently, since they're unrelated
# upstream repos that move on their own schedules. Splitting them into
# their own files means each just has a plain `rev`, no naming clash.
#
# Hash-line lookup uses `nix-instantiate --eval`, not regex: the fetcher
# (fetchurl/fetchzip) in each file is swapped for a probe function that
# reports `builtins.unsafeGetAttrPos "hash"` for its own call site, so
# we edit the exact line Nix says `hash` is on, instead of pattern-
# matching "the line after a URL containing X" against source text.
#
# `rev` and `hash` in a given file must move together: probing happens
# against the untouched original (line numbers don't depend on rev's
# value, so this is safe to do before writing anything), then every
# fallible step (probing, prefetching, hashing) runs against a scratch
# copy. The real file is only overwritten by a single `mv` once that
# pin's whole update has succeeded — never left half-edited.
#
# Implements the "commit" supportedFeatures contract: on success prints
# a JSON array describing what changed.
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

# pkgs/by-name/pi/piper-tts/g2pw-model -> up 5 levels -> nixpkgs root
nixpkgs_root="$(cd "$script_dir/../../../../.." && pwd)"

g2pw_file="default.nix"
bert_file="bert-base-chinese-tokenizer.nix"
changed_attrs=()
changed_files=()

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

sri_of_url() {
    # $1 = url, $2 = "--unpack" or ""
    local url="$1" unpack="${2:-}"
    local base32
    base32=$(nix-prefetch-url $unpack --type sha256 "$url" 2>/dev/null | tail -1)
    nix hash convert --hash-algo sha256 --to sri "$base32"
}

# Evaluates $file with its $fetcher_attr (fetchurl/fetchzip) replaced by a
# probe. The probe doesn't fetch anything: for every call site it traces
# "PROBEHASH <line> <url>" (the line `hash` is on, plus the url being
# fetched, so callers can tell multiple call sites apart) and returns
# null in its place, so evaluation carries on to the next call site
# instead of stopping dead at the first one.
#
# Built via placeholder substitution rather than direct bash
# interpolation, because both Nix and bash use `${...}` — interpolating
# $file straight into the Nix source next to Nix's own `${rev}` would be
# exactly the kind of ambiguous-quoting mess that broke the perl version.
probe_hash_lines() {
    local file="$1" fetcher_attr="$2"
    local expr='
      let
        pkgs = import <nixpkgs> { };
        probe = args:
          builtins.trace
            "PROBEHASH ${toString (builtins.unsafeGetAttrPos "hash" args).line} ${args.url}"
            null;
      in
        pkgs.callPackage ./__FILE__ { __FETCHER__ = probe; }
    '
    expr="${expr//__FILE__/$file}"
    expr="${expr//__FETCHER__/$fetcher_attr}"
    NIX_PATH="nixpkgs=$nixpkgs_root" nix-instantiate --eval --strict --expr "$expr" 2>&1 >/dev/null |
        grep -oP 'PROBEHASH \K.*' || true
}

# Replaces the hash on a known line number and verifies the line
# actually changed — a no-op match here means the line number was
# wrong, and that should be a hard failure, not a silent success.
update_hash_at_line() {
    local file="$1" line="$2" new_hash="$3"
    local after
    sed -i "${line}s|hash = \"[^\"]*\";|hash = \"${new_hash}\";|" "$file"
    after=$(sed -n "${line}p" "$file")
    if [[ "$after" != *"hash = \"${new_hash}\";"* ]]; then
        echo "ERROR: line ${line} in ${file} does not contain the expected hash after substitution (got: ${after})" >&2
        exit 1
    fi
}

### g2pW model (rhasspy/piper-checkpoints) ###################################

old_g2pw_rev=$(grep -oP 'rev = "\K[a-f0-9]+' "$g2pw_file" | head -1)
new_g2pw_rev=$(curl -sfL "https://huggingface.co/api/datasets/rhasspy/piper-checkpoints" | jq -r '.sha')

if [[ -n "$new_g2pw_rev" && "$new_g2pw_rev" != "null" && "$new_g2pw_rev" != "$old_g2pw_rev" ]]; then
    echo "g2pW model: ${old_g2pw_rev} -> ${new_g2pw_rev}" >&2

    # Probe against the untouched original — line numbers don't depend
    # on rev's value, so this is safe before any write happens.
    probed=$(probe_hash_lines "$g2pw_file" fetchzip)
    line=${probed%% *}
    if [[ -z "$line" ]]; then
        echo "ERROR: could not locate the fetchzip call site in $g2pw_file" >&2
        exit 1
    fi

    g2pw_url="https://huggingface.co/datasets/rhasspy/piper-checkpoints/resolve/${new_g2pw_rev}/zh/zh_CN/_resources/g2pw.tar.gz"
    new_g2pw_hash=$(sri_of_url "$g2pw_url" "--unpack")

    cp "$g2pw_file" "$work/$g2pw_file"
    sed -i "s|rev = \"${old_g2pw_rev}\";|rev = \"${new_g2pw_rev}\";|" "$work/$g2pw_file"
    if ! grep -qF "rev = \"${new_g2pw_rev}\";" "$work/$g2pw_file"; then
        echo "ERROR: failed to update rev in $g2pw_file (old_rev '${old_g2pw_rev}' not found?)" >&2
        exit 1
    fi
    update_hash_at_line "$work/$g2pw_file" "$line" "$new_g2pw_hash"

    mv "$work/$g2pw_file" "$g2pw_file"

    changed_attrs+=("g2pwModel")
    changed_files+=("$(pwd)/${g2pw_file}")
fi

### bert-base-chinese tokenizer ##############################################

old_bert_rev=$(grep -oP 'rev = "\K[a-f0-9]+' "$bert_file")
new_bert_rev=$(curl -sfL "https://huggingface.co/api/models/google-bert/bert-base-chinese" | jq -r '.sha')

if [[ -n "$new_bert_rev" && "$new_bert_rev" != "null" && "$new_bert_rev" != "$old_bert_rev" ]]; then
    echo "bert-base-chinese: ${old_bert_rev} -> ${new_bert_rev}" >&2

    probed=$(probe_hash_lines "$bert_file" fetchurl)
    if [[ -z "$probed" ]]; then
        echo "ERROR: could not locate any fetchurl call sites in $bert_file" >&2
        exit 1
    fi

    # Resolve every (line, hash) pair before touching any file — all
    # three network fetches must succeed before we write anything.
    declare -A bert_line bert_hash
    for fname in config.json vocab.txt tokenizer_config.json; do
        match=$(grep -F "/${fname}" <<<"$probed" || true)
        line=${match%% *}
        if [[ -z "$line" ]]; then
            echo "ERROR: no fetchurl call site found for $fname in $bert_file" >&2
            exit 1
        fi
        bert_line[$fname]="$line"
        bert_hash[$fname]=$(sri_of_url "https://huggingface.co/google-bert/bert-base-chinese/resolve/${new_bert_rev}/${fname}")
    done

    cp "$bert_file" "$work/$bert_file"
    sed -i "s|rev = \"${old_bert_rev}\";|rev = \"${new_bert_rev}\";|" "$work/$bert_file"
    if ! grep -qF "rev = \"${new_bert_rev}\";" "$work/$bert_file"; then
        echo "ERROR: failed to update rev in $bert_file (old_rev '${old_bert_rev}' not found?)" >&2
        exit 1
    fi
    for fname in config.json vocab.txt tokenizer_config.json; do
        update_hash_at_line "$work/$bert_file" "${bert_line[$fname]}" "${bert_hash[$fname]}"
    done

    mv "$work/$bert_file" "$bert_file"

    changed_attrs+=("bert-base-chinese-tokenizer")
    changed_files+=("$(pwd)/${bert_file}")
fi

if [[ ${#changed_attrs[@]} -eq 0 ]]; then
    echo "[]"
    exit 0
fi

jq -n \
    --arg attrPath "g2pwModel" \
    --arg body "Updated: $(
        IFS=,
        echo "${changed_attrs[*]}"
    )" \
    --argjson files "$(printf '%s\n' "${changed_files[@]}" | jq -R . | jq -s .)" \
    '[{attrPath: $attrPath, files: $files, commitBody: $body}]'
