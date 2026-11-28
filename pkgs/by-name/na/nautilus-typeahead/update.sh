#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash --packages cacert git pacman nix
# shellcheck shell=bash
##
## Automatic `updateScript` for `patch.nix` of `nautilus-typeahead`
##
## Available flag:
##   `--dry-run`: do not write to the actual file, only print to stdout
##

set -eo pipefail
set -x

REGEX_REV='[a-f0-9]+'

init_dir=$(realpath "$(dirname "$0")")
tmp_dir=$(mktemp -d)
cd "$tmp_dir"

git clone --filter=blob:none https://aur.archlinux.org/nautilus-typeahead.git
cd nautilus-typeahead

## pacman's `makepkg` generates normalized source info
## from the package definitions
makepkg --printsrcinfo > .SRCINFO

read_src_info() {
  local key=$1
  sed --silent -E s/$'\t'"$key = (.*)$/\1/p" .SRCINFO
}
pkgver=$(read_src_info pkgver | head -1)
pkgrel=$(read_src_info pkgrel | head -1)

rev=$(read_src_info source \
  | sed --silent -E "s|.*albertvaka/nautilus.*commit=($REGEX_REV)$|\1|p" \
  | head -1)

rm -rf "$tmp_dir"
cd "$init_dir"

new_file=$(sed -E "
  s/(^\s*pkgver\s*=\s*\")(.*)(\".*)$/\1$pkgver\3/;
  s/(^\s*pkgrel\s*=\s*\")(.*)(\".*)$/\1$pkgrel\3/;
  s/(^\s*rev\s*=\s*\")($REGEX_REV)(\".*)$/\1$rev\3/;
  s/(^\s*outputHash\s*=)(.*)$/\1 lib.fakeHash;/;
" patch.nix)

set +x -v

package_expr() {
  local pkg=$1
  echo "with import <nixpkgs> {}; callPackage ($pkg) {}"
}
package=$(package_expr "$new_file")

test_instantiate() {
  nix-instantiate --eval --expr "$package" --attr "$@"
}
[[ $(test_instantiate "pkgver") == "\"$pkgver\"" ]]
[[ $(test_instantiate "pkgrel") == "\"$pkgrel\"" ]]
[[ $(test_instantiate "rev") == "\"$rev\"" ]]

test_build=$(nix-build --expr "$package" 2>&1 || true)
echo "$test_build" >&2

set +v
outputHash=$(
  sed --silent -E 's/.*got:\s*(sha256-.*=)\s*$/\1/p' <<< "$test_build" \
  | head -1
)
echo "outputHash: $outputHash" >&2

hashed_file=$(sed -E "
  s|(^\s*outputHash\s*=)(.*)$|\1 \"$outputHash\";|
" <<< "$new_file")
## ^ note that here we must use `s|..|..|` instead of `s/../../`
## because "$outputHash" may contain `/`

nix-build --expr "$(package_expr "$hashed_file")" --no-out-link

if [[ "$1" == "--dry-run" ]]; then
  echo "$hashed_file"
else
  echo "$hashed_file" > patch.nix
fi
