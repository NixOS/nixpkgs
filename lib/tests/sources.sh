#!/usr/bin/env bash
set -euo pipefail

# Use
#     || die
die() {
  echo >&2 "test case failed: " "$@"
  exit 1
}

if test -n "${TEST_LIB:-}"; then
  export NIX_PATH=nixpkgs="$(dirname "$TEST_LIB")"
else
  export NIX_PATH=nixpkgs="$(cd $(dirname ${BASH_SOURCE[0]})/../..; pwd)"
fi

work="$(mktemp -d)"
clean_up() {
  rm -rf "$work"
}
trap clean_up EXIT
cd $work

touch {README.md,module.o,foo.bar}

# nix-instantiate doesn't write out the source, only computing the hash, so
# this uses the experimental nix command instead.

dir="$(nix eval --impure --raw --expr '(with import <nixpkgs/lib>; "${
  cleanSource ./.
}")')"
(cd $dir; find) | sort -f | diff -U10 - <(cat <<EOF
.
./foo.bar
./README.md
EOF
) || die "cleanSource 1"


dir="$(nix eval --impure --raw --expr '(with import <nixpkgs/lib>; "${
  cleanSourceWith { src = '"$work"'; filter = path: type: ! hasSuffix ".bar" path; }
}")')"
(cd $dir; find) | sort -f | diff -U10 - <(cat <<EOF
.
./module.o
./README.md
EOF
) || die "cleanSourceWith 1"

dir="$(nix eval --impure --raw --expr '(with import <nixpkgs/lib>; "${
  cleanSourceWith { src = cleanSource '"$work"'; filter = path: type: ! hasSuffix ".bar" path; }
}")')"
(cd $dir; find) | sort -f | diff -U10 - <(cat <<EOF
.
./README.md
EOF
) || die "cleanSourceWith + cleanSource"

echo >&2 tests ok
