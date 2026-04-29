#!/usr/bin/env bash
# Fix intra-workspace path deps in vendored git-source crates.
#
# fetchCargoVendor copies crate dirs from git sources verbatim, without
# rewriting intra-workspace path deps the way `cargo vendor` would.  Build
# tools such as substrate-wasm-builder spawn a fresh cargo with no lock file;
# that fresh resolution follows path deps literally and chokes on
# monorepo-relative paths that no longer exist in the flattened vendor layout.
#
# For each source-git-N dir: build a crate-name->dir map, then for each
# vendored Cargo.toml redirect each broken path dep to the correct sibling
# vendor dir.  Dep sections may list `package = "actual-name"` after `path =`,
# so we buffer each section and resolve it only when we leave.
set -euo pipefail

vendor_dir="$1"

flush_dep() {
    local name="${dep_pkg:-$dep_alias}"
    name=$(echo "$name" | tr _ -)
    local name_u
    name_u=$(echo "$name" | tr - _)
    if [[ -n "$name" && -n "$dep_path" && ! -d "$crate_dir/$dep_path" ]]; then
        local target="${crate_map[$name]:-${crate_map[$name_u]:-}}"
        if [[ -n "$target" ]]; then
            local rel
            rel=$(realpath --relative-to="$crate_dir" "$target")
            sed -i "s|path = \"$dep_path\"|path = \"$rel\"|g" "$toml"
        fi
    fi
    dep_alias="" dep_pkg="" dep_path=""
}

for src_dir in "$vendor_dir"/source-git-*/; do
    [[ -d "$src_dir" ]] || continue

    declare -A crate_map=()
    for d in "$src_dir"*/; do
        name=$(awk '
            /^\[package\]/ { in_pkg = 1 }
            in_pkg && /^name[[:space:]]*=/ {
                gsub(/.*=[[:space:]]*"|"[[:space:]]*$/, "")
                print; exit
            }
        ' "$d/Cargo.toml" 2>/dev/null) || true
        [[ -n "$name" ]] && crate_map["$name"]="${d%/}"
    done

    for toml in "$src_dir"*/Cargo.toml; do
        dep_alias="" dep_pkg="" dep_path=""
        crate_dir=$(dirname "$toml")
        while IFS= read -r line; do
            case "$line" in
                \[*dependencies.*\])
                    flush_dep
                    dep_alias="${line##*dependencies.}"
                    dep_alias="${dep_alias%%\]*}" ;;
                package\ =\ *)
                    dep_pkg="${line#*\"}"
                    dep_pkg="${dep_pkg%\"*}" ;;
                path\ =\ *)
                    dep_path="${line#*\"}"
                    dep_path="${dep_path%\"*}" ;;
                \[*)
                    flush_dep ;;
            esac
        done < "$toml"
        flush_dep
    done

    unset crate_map
done
