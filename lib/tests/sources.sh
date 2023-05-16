#!/usr/bin/env bash
<<<<<<< HEAD

# Tests lib/sources.nix
# Run:
# [nixpkgs]$ lib/tests/sources.sh
# or:
# [nixpkgs]$ nix-build lib/tests/release.nix

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
set -euo pipefail
shopt -s inherit_errexit

# Use
#     || die
die() {
  echo >&2 "test case failed: " "$@"
  exit 1
}

if test -n "${TEST_LIB:-}"; then
  NIX_PATH=nixpkgs="$(dirname "$TEST_LIB")"
else
  NIX_PATH=nixpkgs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
fi
export NIX_PATH

work="$(mktemp -d)"
clean_up() {
  rm -rf "$work"
}
trap clean_up EXIT
cd "$work"

<<<<<<< HEAD
# Crudely unquotes a JSON string by just taking everything between the first and the second quote.
# We're only using this for resulting /nix/store paths, which can't contain " anyways,
# nor can they contain any other characters that would need to be escaped specially in JSON
# This way we don't need to add a dependency on e.g. jq
crudeUnquoteJSON() {
    cut -d \" -f2
}

touch {README.md,module.o,foo.bar}

dir="$(nix-instantiate --eval --strict --read-write-mode --json --expr '(with import <nixpkgs/lib>; "${
  cleanSource ./.
}")' | crudeUnquoteJSON)"
=======
touch {README.md,module.o,foo.bar}

# nix-instantiate doesn't write out the source, only computing the hash, so
# this uses the experimental nix command instead.

dir="$(nix eval --impure --raw --expr '(with import <nixpkgs/lib>; "${
  cleanSource ./.
}")')"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
(cd "$dir"; find) | sort -f | diff -U10 - <(cat <<EOF
.
./foo.bar
./README.md
EOF
) || die "cleanSource 1"


<<<<<<< HEAD
dir="$(nix-instantiate --eval --strict --read-write-mode --json --expr '(with import <nixpkgs/lib>; "${
  cleanSourceWith { src = '"$work"'; filter = path: type: ! hasSuffix ".bar" path; }
}")' | crudeUnquoteJSON)"
=======
dir="$(nix eval --impure --raw --expr '(with import <nixpkgs/lib>; "${
  cleanSourceWith { src = '"$work"'; filter = path: type: ! hasSuffix ".bar" path; }
}")')"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
(cd "$dir"; find) | sort -f | diff -U10 - <(cat <<EOF
.
./module.o
./README.md
EOF
) || die "cleanSourceWith 1"

<<<<<<< HEAD
dir="$(nix-instantiate --eval --strict --read-write-mode --json --expr '(with import <nixpkgs/lib>; "${
  cleanSourceWith { src = cleanSource '"$work"'; filter = path: type: ! hasSuffix ".bar" path; }
}")' | crudeUnquoteJSON)"
=======
dir="$(nix eval --impure --raw --expr '(with import <nixpkgs/lib>; "${
  cleanSourceWith { src = cleanSource '"$work"'; filter = path: type: ! hasSuffix ".bar" path; }
}")')"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
(cd "$dir"; find) | sort -f | diff -U10 - <(cat <<EOF
.
./README.md
EOF
) || die "cleanSourceWith + cleanSource"

echo >&2 tests ok
