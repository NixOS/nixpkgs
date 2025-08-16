#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix nix-prefetch-github

nixpkgs="$(git rev-parse --show-toplevel || (printf 'Could not find root of nixpkgs repo\nAre we running from within the nixpkgs git repo?\n' >&2; exit 1))"

narhash() {
    nix --extra-experimental-features nix-command store prefetch-file --json "$1" | jq -r .hash
}

set -euo pipefail

declare -A architectures
declare -A versions
declare -A hashes

architectures["x86_64-linux"]="x86_64-unknown-linux-gnu"

BASE_URL="https://files.nordicsemi.com/artifactory/swtools/external/nrfutil"

for a in ${!architectures[@]}; do
    versions["$a"]=$(curl "$BASE_URL/index/${architectures[${a}]}/index.json" | jq -r '.packages.nrfutil.latest_version')
    hashes["$a"]=$(narhash "$BASE_URL/packages/nrfutil/nrfutil-${architectures[${a}]}-${versions[${a}]}.tar.gz")
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
