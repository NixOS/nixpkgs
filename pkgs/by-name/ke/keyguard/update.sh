#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

export NIXPKGS_ALLOW_UNFREE=1

latest=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/AChep/keyguard-app/releases/latest)
latestTag=$(echo "$latest" | jq -r ".tag_name")
latestName=$(echo "$latest" | jq -r ".name")
latestVersion=$(echo "$latestName" | awk -F'v|-' '{print $2}')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; keyguard.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(nix-prefetch-url --unpack "https://github.com/AChep/keyguard-app/archive/refs/tags/${latestTag}.tar.gz"))
update-source-version keyguard $latestVersion $hash

sed -i 's/tag = "r[0-9]\+\(\.[0-9]\+\)\?";/tag = "'"$latestTag"'";/g' "$ROOT/package.nix"

# The vendored crates follow Cargo.lock, so their hashes change with the
# source. An empty hash makes Nix report the correct one.
refresh-cargo-hash() {
    local attr=$1 name=$2 found

    sed -i "s|^  ${name} = \"sha256-[^\"]*\";|  ${name} = \"\";|" "$ROOT/package.nix"

    found=$(nix-build --no-out-link -A "keyguard.passthru.${attr}" 2>&1 \
        | sed -n 's/^ *got: \(sha256-[^ ]*\)$/\1/p' | tail -n 1) || true
    if [[ -z "$found" ]]; then
        echo "error: could not determine the hash of $attr" >&2
        exit 1
    fi

    sed -i "s|^  ${name} = \"\";|  ${name} = \"${found}\";|" "$ROOT/package.nix"
    echo "updated $name = $found"
}

refresh-cargo-hash rootCargoVendor rootCargoHash
refresh-cargo-hash cryptoCargoVendor cryptoCargoHash

$(nix-build -A keyguard.mitmCache.updateScript)
