#!/usr/bin/env bash

set -eu -o pipefail

readonly scriptdir nixpkgs expr outputs
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
nixpkgs="${scriptdir}/../../../../.."
expr="with import \"${nixpkgs}\" {}; builtins.map (out: pipewire.\${out}) pipewire.outputs"
mapfile -t outputs < <(nix-build --no-out-link -E "${expr}")

find "${outputs[@]}" -type f -iwholename "*.conf.json" -print0 | \
    xargs -0 install -m 660 --target-directory "${scriptdir}"
