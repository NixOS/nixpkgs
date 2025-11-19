#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix

set -euo pipefail
echoerr() { echo "$@" 1>&2; }

fetchgithub() {
    set +eo pipefail
    nix-build -A "$1" 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g'
    set -eo pipefail
}

fname="$1"
echoerr "Working on $fname"
shift

# Fetch latest tags from the repo, leave only stable and lts, use version sort in reverse order.
all_tags=$(curl -L -s ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} https://api.github.com/repos/ClickHouse/ClickHouse/tags \
           | jq -r '.[].name | select(test("-(stable|lts)$"))' \
           | sort -Vr)

# Fail if no tags found
if [[ -z "$all_tags" ]]; then
    echoerr "Error: no suitable tag found in ClickHouse repo"
    exit 1
fi

pname="clickhouse"
if [[ "$fname" == *lts.nix ]]; then
    all_tags=$(echo "$all_tags" | grep -- "-lts$")
    pname="clickhouse-lts"
fi

latest_tag=$(echo "$all_tags" | head -n1)
version=${latest_tag##v}

# Do nothing if latest version is already there.
if grep -q "version = \"$version\"" "$fname"; then
    echoerr "Version $version is already the latest in $fname"
    exit 0
fi

echoerr "Latest tag for $fname: $latest_tag (version $version)"

# Get the annotated tag commit SHA.
rev=$(curl -L -s ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} "https://api.github.com/repos/clickhouse/clickhouse/git/ref/tags/$latest_tag" \
      | jq -r '.object.sha')
rev=$(curl -L -s ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} "https://api.github.com/repos/clickhouse/clickhouse/git/tags/$rev" \
      | jq -r '.object.sha')
echoerr "Resolved commit hash for tag $latest_tag: $rev"

# Update version.
sed -i -E "s@(version = \").*(\";)@\1$version\2@" "$fname"
grep -q "$version" "$fname"

# Update Git hash.
sed -i -E "s@(rev = \").*(\";)@\1$rev\2@" "$fname"
grep -q "$rev" "$fname"

# Update source hash.
# First, put lib.fakeHash value.
tmp_src_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
sed -i -E "s@(hash = \").*(\";)@\1$tmp_src_hash\2@" "$fname"
grep -q "$tmp_src_hash" "$fname"

# Next, we need to run actual build due to presence of postFetch script.
echoerr "Running fetchFromGitHub on $pname to get new sources hash"

src_hash=$(fetchgithub "$pname.src")
if [[ -z "$src_hash" ]]; then
    echoerr "Error: failed to get source hash from nix-build"
    exit 1
fi

# Finally, update the source hash.
echoerr "New src hash: $src_hash"
sed -i -E "s@(hash = \").*(\";)@\1$src_hash\2@" "$fname"
grep -q "$src_hash" "$fname"
