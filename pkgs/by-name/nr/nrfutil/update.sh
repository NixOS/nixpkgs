#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix nix-prefetch-github xq-xml

nixpkgs="$(git rev-parse --show-toplevel || (printf 'Could not find root of nixpkgs repo\nAre we running from within the nixpkgs git repo?\n' >&2; exit 1))"

narhash() {
    nix --extra-experimental-features nix-command store prefetch-file --json "$1" | jq -r .hash
}

set -euo pipefail

declare -A architectures
declare -A versions
declare -A hashes

architectures["x86_64-linux"]="x86_64-unknown-linux-gnu"
architectures["x86_64-darwin"]="x86_64-apple-darwin"
architectures["aarch64-darwin"]="aarch64-apple-darwin"

binary_list=$(curl "https://developer.nordicsemi.com/.pc-tools/nrfutil/" | xq -q "#files" | grep -o -E 'nrfutil-(x86_64|aarch64)-.*?.gz' | cut -d' ' -f 1)

for a in ${!architectures[@]}; do
    versions["$a"]=$(echo "$binary_list" | grep "${architectures[${a}]}" | sed -r "s/nrfutil-${architectures[${a}]}-(.*?).tar.gz/\\1/" | tail -n 1)
    echo "https://developer.nordicsemi.com/.pc-tools/nrfutil/nrfutil-${architectures[${a}]}-${versions[${a}]}.tar.gz"
    hashes["$a"]=$(narhash "https://developer.nordicsemi.com/.pc-tools/nrfutil/nrfutil-${architectures[${a}]}-${versions[${a}]}.tar.gz")
done

{
    printf "{\n"
    printf "  version = \"${versions["x86_64-linux"]}\";\n"
    for a in ${!architectures[@]}; do
        printf "  ${a} = {\n"
        printf "    name = \"${architectures[${a}]}\";\n"
        printf "    hash = \"${hashes[${a}]}\";\n"
        printf "  };\n"
    done
    printf "}\n"
} > "${nixpkgs}/pkgs/by-name/nr/nrfutil/source.nix"
