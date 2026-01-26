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
declare -a packages

architectures["x86_64-linux"]="x86_64-unknown-linux-gnu"
architectures["aarch64-linux"]="aarch64-unknown-linux-gnu"
# NOTE: segger-jlink is not yet packaged for darwin
# architectures["x86_64-darwin"]="x86_64-apple-darwin"
# architectures["aarch64-darwin"]="aarch64-apple-darwin"

packages=(
    "nrfutil"
    "nrfutil-91"
    "nrfutil-ble-sniffer"
    "nrfutil-completion"
    "nrfutil-device"
    "nrfutil-mcu-manager"
    "nrfutil-npm"
    "nrfutil-nrf5sdk-tools"
    "nrfutil-sdk-manager"
    "nrfutil-suit"
    "nrfutil-toolchain-manager"
    "nrfutil-trace"
)


BASE_URL="https://files.nordicsemi.com/artifactory/swtools/external/nrfutil"

for a in "${!architectures[@]}"; do
    ARCH="${architectures["${a}"]}"
    INDEX=$(curl "$BASE_URL/index/${ARCH}/index.json")
    for p in "${!packages[@]}"; do
        PKG="${packages["${p}"]}"

        jq -e -r ".packages.\"${PKG}\"" <<< "$INDEX" 1>/dev/null && {
            versions["$a-$p"]=$(jq -r ".packages.\"${PKG}\".latest_version" <<< "$INDEX")
            hashes["$a-$p"]=$(narhash "$BASE_URL/packages/${PKG}/${PKG}-${ARCH}-${versions["$a-$p"]}.tar.gz")
        }
    done
done

{
    printf "{\n"
    for a in "${!architectures[@]}"; do
        printf "  %s = {\n" "$a"
        printf "    triplet = \"%s\";\n" "${architectures["${a}"]}"
        printf "    packages = {\n"
        for p in "${!packages[@]}"; do
            test ${versions["$a-$p"]+_} && {
                printf "      %s = {\n" "${packages["${p}"]}"
                printf "        version = \"%s\";\n" "${versions["$a-$p"]}"
                printf "        hash = \"%s\";\n" "${hashes["$a-$p"]}"
                printf "      };\n"
            }
        done
        printf "    };\n"
        printf "  };\n"
    done
    printf "}\n"
} > "${nixpkgs}/pkgs/by-name/nr/nrfutil/source.nix"
