#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash nix curl jq gawk gnused nixfmt

set -euo pipefail

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
FILE_PATH="$SCRIPT_DIR/package.nix"

LATEST_TAG=$(curl -s https://api.github.com/repos/ad-freiburg/qlever/releases/latest | jq -r '.tag_name')

VERSION_OLD="${UPDATE_NIX_OLD_VERSION:-$(grep -oP '(?<=version = ")[^"]+' "$FILE_PATH")}"
VERSION_NEW="${LATEST_TAG#v}"

if [[ "$VERSION_NEW" == "$VERSION_OLD" ]]; then
    echo "QLever already up to date: $VERSION_NEW"
    exit 0
fi

CMAKE_URL="https://raw.githubusercontent.com/ad-freiburg/qlever/$LATEST_TAG/CMakeLists.txt"
CMAKE_FILE=$(curl -s "$CMAKE_URL")

prefetch_github_hash() {
    local owner=$1
    local repo=$2
    local rev=$3
    local fetch_submodules=${4:-false}

    local expr="with import <nixpkgs> {}; fetchFromGitHub { \
        owner = \"$owner\"; \
        repo = \"$repo\"; \
        rev = \"$rev\"; \
        fetchSubmodules = $fetch_submodules; \
        hash = \"\"; \
    }"

    output=$(nix-build --no-out-link -E "$expr" 2>&1)

    echo "$output" | awk '/got:/ {print $NF}'
}

# Extract the pinned revision/tag for a FetchContent_Declare block.
extract_git_tag() {
    local dep_name=$1
    local result

    result=$(echo "$CMAKE_FILE" | awk -v dep="$dep_name" '
        /FetchContent_Declare\(/ { expect_name=1; next }
        expect_name {
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
            in_block = ($0 == dep)
            expect_name = 0
            next
        }
        in_block && /GIT_TAG/ {
            for (i=1; i<=NF; i++)
                if ($i == "GIT_TAG") { print $(i+1); exit }
        }
        in_block && /[[:space:]]URL[[:space:]]/ && !/URL_HASH/ {
            for (i=1; i<=NF; i++)
                if ($i == "URL") { print "URL:" $(i+1); exit }
        }
        in_block && /^[[:space:]]*\)/ { in_block=0 }
    ')

    if [[ "$result" == URL:* ]]; then
        # e.g. .../download/v3.12.0/json.tar.xz -> v3.12.0
        echo "${result#URL:}" | grep -Po '(?<=/download/)[^/]+'
    else
        echo "$result"
    fi
}

# Get the current revision/tag for a fetchFromGitHub block.
get_current_git_tag() {
    local attr_name=$1
    local type=$2

    awk "/$attr_name = fetchFromGitHub/,/};/" "$FILE_PATH" |
        sed -n "s/.*$type = \"\([^\"]*\)\".*/\1/p"
}

FAILED=()

update_dep() {
    local cmake_dep=$1
    local owner=$2
    local repo=$3
    local type=${4:-rev}
    local submodules=${5:-false}

    echo "- $cmake_dep:"

    rev=$(extract_git_tag "$cmake_dep")
    if [ -z "$rev" ]; then
        echo "    Error: could not find GIT_TAG for '$cmake_dep' in CMakeLists.txt"
        FAILED+=("$cmake_dep")
        return 0
    fi

    current_rev=$(get_current_git_tag "$cmake_dep" "$type")
    if [ "$current_rev" = "$rev" ]; then
        echo "    Skipping: $type already up to date ($rev)"
        return 0
    fi

    echo "    $type: $current_rev -> $rev. Prefetching hash..."

    hash=$(prefetch_github_hash "$owner" "$repo" "$rev" "$submodules")
    if [ -z "$hash" ]; then
        echo "    Error: Failed to prefetch hash for $owner/$repo@$rev (Is the repository/rev valid?)"
        FAILED+=("$cmake_dep")
        return 0
    fi

    sed -i "/$cmake_dep = fetchFromGitHub {/,/};/ s|$type = \".*\";|$type = \"$rev\";|" "$FILE_PATH"
    sed -i "/$cmake_dep = fetchFromGitHub {/,/};/ s|hash = \".*\";|hash = \"$hash\";|" "$FILE_PATH"
    echo "    Done."
}

echo "Updating QLever to $VERSION_NEW"

sed -i "s|version = \"$VERSION_OLD\"|version = \"$VERSION_NEW\"|" "$FILE_PATH"

HASH=$(prefetch_github_hash "ad-freiburg" "qlever" "$LATEST_TAG" true)
sed -i "/src = fetchFromGitHub {/,/};/ s|hash = \".*\";|hash = \"$HASH\";|" "$FILE_PATH"

echo ""
echo "Updating dependencies:"

# NOTE: cmake_dep must match the identifier on the line after FetchContent_Declare(

# Read configuration line-by-line. Skip empty lines and comments.
while read -r cmake_dep owner repo type submodules; do
    [[ -z "$cmake_dep" || "$cmake_dep" == \#* ]] && continue

    # use "-" as a placeholder for visual alignment
    [[ "$type" == "-" ]] && type=""
    [[ "$submodules" == "-" ]] && submodules=""

    update_dep "$cmake_dep" "$owner" "$repo" "${type:-rev}" "${submodules:-false}"
done <<'EOF'
# CMAKE_DEP        OWNER         REPO                                TYPE  SUBMODULES
fsst               cwida         fsst                                -     -
re2                google        re2                                 -     -
googletest         google        googletest                          -     -
nlohmann-json      nlohmann      json                                tag   -
antlr              antlr         antlr4                              -     -
range-v3           joka921       range-v3                            -     -
spatialjoin        ad-freiburg   spatialjoin                         -     true
ctre               hanickadot    compile-time-regular-expressions    -     -
abseil             abseil        abseil-cpp                          -     -
s2                 google        s2geometry                          -     -
EOF

echo ""
echo "Formatting $FILE_PATH"

nixfmt "$FILE_PATH"

if [ ${#FAILED[@]} -gt 0 ]; then
    echo ""
    echo "Warning: the following deps could not be updated:"
    printf '  - %s\n' "${FAILED[@]}"
    exit 1
fi

echo ""
echo "All dependencies updated for QLever $LATEST_TAG"
