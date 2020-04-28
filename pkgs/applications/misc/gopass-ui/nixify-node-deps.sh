#!/usr/bin/env nix-shell
#!nix-shell -p nodePackages.node2nix -i bash
set -euf -o pipefail
script_dir="$(cd "$(dirname "$0")" && pwd)"

src_dir="${1:-"."}"
out_dir="${2:-"$script_dir"}"

# GOPASS_UI_SRC_URL_OVERRIDE="https://github.com/jraygauthier/gopass-ui/archive/905eb0e329cbf040c684b1077eeecaa5c28fe669.tar.gz"

if [[ "x" = "${GOPASS_UI_SRC_URL_OVERRIDE+x}" ]]; then
  # Becomes the default and allow quick patches fixing the oft seen 'package-lock.json':
  # "TypeError: Cannot read property 'substr' of undefined".
  # This occurs when some info expected by pypi2nix such as the 'integrity' / 'resolved'
  # is missing for some packages in 'package-lock.json'.
  src_dir="$(\
    nix-prefetch-url --print-path --unpack \
    "$GOPASS_UI_SRC_URL_OVERRIDE" \
    0w3spkanx4v69drxrjanapbha269rqq20nv4lznbykynfqnxb35g \
      | tail -n 1)"
fi

echo "src_dir='$src_dir'"
echo "out_dir='$out_dir'"

# HACK: Around the following errors and which allow proper relative
# paths in output files:
#   Error: ENOENT: no such file or directory, open './package.json'
#   Error: ENOENT: no such file or directory, open './package-lock.json'
tmp_pkg_dir="$out_dir"
cp -t "$tmp_pkg_dir" "$src_dir/package-lock.json" "$src_dir/package.json"
chmod u+w "$tmp_pkg_dir/package-lock.json" "$tmp_pkg_dir/package.json"

trap "rm '${tmp_pkg_dir}/package-lock.json' '${tmp_pkg_dir}/package.json'" EXIT

node2nix_args=( --development --nodejs-12 \
  -i "$tmp_pkg_dir/package.json" \
  -l "$tmp_pkg_dir/package-lock.json" \
  --no-copy-node-env \
  --node-env "../../../development/node-packages/node-env.nix" \
  --output "$out_dir/node-packages.nix" \
  --composition "$out_dir/node-composition.nix" \
)

echo "node2nix" "${node2nix_args[@]}"
node2nix "${node2nix_args[@]}"