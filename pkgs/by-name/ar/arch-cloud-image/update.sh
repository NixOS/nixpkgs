#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils curl gnused lix

# Update arch-cloud-image to the newest Arch snapshot.

set -euo pipefail

readonly package=arch-cloud-image
readonly expression="pkgs/by-name/ar/$package/package.nix"
readonly mirror=https://geo.mirror.pkgbuild.com/images

currentVersion="$(
    sed -n 's/^ *release ? "\([^"]*\)",/\1/p' "$expression"
)"

if [[ -z "$currentVersion" ]]; then
    echo "error: could not read the current release from $expression" >&2
    exit 1
fi

latestVersion="$(
    curl --silent --show-error --fail --location "$mirror/" \
        | sed -n 's|.*"\(v[0-9][0-9.]*\)/".*|\1|p' \
        | sort --version-sort \
        | tail --lines=1 \
        | sed 's/^v//'
)"

if [[ -z "$latestVersion" ]]; then
    echo "error: could not determine the newest snapshot from $mirror/" >&2
    exit 1
fi

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "$package is already up to date: $currentVersion"
    exit 0
fi

echo "updating $package: $currentVersion -> $latestVersion"

architectures="$(
    sed -n '/archHashes ? {/,/}/p' "$expression" \
        | sed -n 's/^ *\([a-zA-Z0-9_]*\) = "sha256-.*/\1/p'
)"

if [[ -z "$architectures" ]]; then
    echo "error: no pinned architectures found in $expression" >&2
    exit 1
fi

sed --in-place "s|release ? \"[^\"]*\"|release ? \"$latestVersion\"|" "$expression"

for arch in $architectures; do
    url="$mirror/v$latestVersion/Arch-Linux-$arch-basic-$latestVersion.qcow2"
    echo "hashing $arch: $url"
    storePath="$(nix-prefetch-url --type sha256 --print-path "$url" | tail --lines=1)"
    hash="$(nix --extra-experimental-features nix-command hash file \
        --sri --type sha256 "$storePath")"
    sed --in-place "s|^ *$arch = \"sha256-[^\"]*\";|    $arch = \"$hash\";|" "$expression"
done

echo
echo "updated to $latestVersion. Verify with:"
echo
echo "    nix-build -A $package"
echo "    nix-build -A tests.testers.runImageTest-arch"
