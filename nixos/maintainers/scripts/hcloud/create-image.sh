#!/usr/bin/env nix-shell
#! nix-shell -i bash -p hcloud-upload-image

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo >&2 "Usage: $0 <x86|arm>"
    exit 64
fi

hetzner_arch="$1"
case "$hetzner_arch" in
    x86)
        nix_arch="x86_64"
        ;;
    arm)
        nix_arch="aarch64"
        ;;
    *)
        echo >&2 "Unknown Hetzner architecture: ${hetzner_arch}"
        exit 64
        ;;
esac

cd "$(dirname "${BASH_SOURCE[0]}")"

nix-build '../../../lib/eval-config.nix' \
   -A config.system.build.image \
   --arg modules "[ ../../../modules/virtualisation/hcloud-image.nix ]" \
   --argstr system "${nix_arch}-linux" \
   -o hcloud

image="$(echo hcloud/nixos-image-hcloud-*.img)"
hcloud-upload-image upload \
    --architecture "${hetzner_arch}" \
    --description "$(basename "${image}")" \
    --image-path "${image}"
