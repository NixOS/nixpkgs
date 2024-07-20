#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnutar jq reuse
set -eu
cd "$(dirname "$(readlink -f "$0")")"/../../..

TMPDIR=$(mktemp -d)
trap 'rm -rf $TMPDIR' EXIT

echo "# Prebuilding sources..."
nix-build -A kdePackages.sources --no-link || true

echo "# Evaluating sources..."
declare -A sources
eval "$(nix-instantiate --eval -A kdePackages.sources --json --strict | jq 'to_entries[] | "sources[" + .key + "]=" + .value' -r)"

echo "# Collecting licenses..."
for k in "${!sources[@]}"; do
    echo "- Processing $k..."

    if [ ! -f "${sources[$k]}" ]; then
        echo "Not found!"
        continue
    fi

    mkdir "$TMPDIR/$k"
    tar -C "$TMPDIR/$k" -xf "${sources[$k]}"

    (cd "$TMPDIR/$k"; reuse lint --json) | jq --arg name "$k" '{$name: .summary.used_licenses | sort}' -c > "$TMPDIR/$k.json"
done

jq -s 'add' -S "$TMPDIR"/*.json > pkgs/kde/generated/licenses.json
