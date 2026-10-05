#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils gawk git gnused jq nix-update

set -euo pipefail

attr=openvino-intel-npu-compiler

# npu_ud_<year>_<week>[_<patch>]_rc<N>, e.g. npu_ud_2026_38_rc1 -> 2026.38-rc1.
version=$(
  git ls-remote --tags --refs https://github.com/openvinotoolkit/npu_compiler 'npu_ud_*' \
    | sed -nE 's|.*refs/tags/npu_ud_([0-9]+)_([0-9]+)(_([0-9]+))?_rc([0-9]+)$|\1 \2 \4 \5|p' \
    | sort -t " " -n -k1,1 -k2,2 -k3,3 -k4,4 \
    | tail -n1 \
    | awk -F '[ ]' '{ printf "%s.%s%s-rc%s\n", $1, $2, ($3 == "" ? "" : "." $3), $4 }'
)

if [[ "$version" == "$(nix-instantiate --eval --raw -A "$attr.version")" ]]; then
  echo "$attr is up to date: $version"
  exit 0
fi

nix-update "$attr" --version "$version"

src=$(nix-build --no-out-link -A "$attr.src")
openvinoRev=$(jq -r .openvinotoolkit "$src/validation/openvino_config.json")
oldOpenvinoRev=$(nix-instantiate --eval --raw -A "$attr.openvinoSrc.rev")

if [[ "$openvinoRev" != "$oldOpenvinoRev" ]]; then
  update-source-version "$attr" --source-key=openvinoSrc --rev="$openvinoRev" --ignore-same-version
fi
