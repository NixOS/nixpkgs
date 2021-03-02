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

dir="$(nix eval --raw '(with import <nixpkgs/lib>; "${
  cleanSource ./.
}")')"
(cd $dir; find) | sort -f | diff -U10 - <(cat <<EOF
.
./foo.bar
./README.md
EOF
) || die "cleanSource 1"


dir="$(nix eval --raw '(with import <nixpkgs/lib>; "${
  cleanSourceWith { src = '"$work"'; filter = path: type: ! hasSuffix ".bar" path; }
}")')"
(cd $dir; find) | sort -f | diff -U10 - <(cat <<EOF
.
./module.o
./README.md
EOF
) || die "cleanSourceWith 1"


dir="$(nix eval --raw '(with import <nixpkgs/lib>; "${
  sources.filter (path: type: ! hasSuffix ".bar" path) ./.
}")')"
(cd $dir; find) | sort -f | diff -U10 - <(cat <<EOF
.
./module.o
./README.md
EOF
) || die "sources.filter"

dir="$(nix eval --raw '(with import <nixpkgs/lib>; "${
  cleanSourceWith { src = cleanSource '"$work"'; filter = path: type: ! hasSuffix ".bar" path; }
}")')"
(cd $dir; find) | sort -f | diff -U10 - <(cat <<EOF
.
./README.md
EOF
) || die "cleanSourceWith + cleanSource"

mkdir -p "$work"/src
touch "$work"/src/{bar.c,bar.o}

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    union (empty ./.) ./src
  }")')"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./src
./src/bar.c
./src/bar.o
EOF
) || die "sources.union: basic"

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    union (empty ./.) (cleanSource ./src)
  }")')"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./src
./src/bar.c
EOF
) || die "sources.union: filtered rhs"


dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    union
      (cleanSourceWith { src = cleanSource ./.;
                         filter = path: type: baseNameOf path != "src"; })
      ./src
  }")'
)"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./foo.bar
./README.md
./src
./src/bar.c
./src/bar.o
EOF
) || die "sources.union: filtered lhs"

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    union 
      (cleanSourceWith { src = cleanSource ./.;
                         filter = path: type: baseNameOf path != "src"; })
      (cleanSourceWith { src = ./src; 
                         filter = path: type: !hasSuffix ".c" path; })
  }")'
)"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./foo.bar
./README.md
./src
./src/bar.o
EOF
) || die "sources.union: lhs filter doesn't influence rhs files"


dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    union
      (cleanSourceWith { src = reparent ./. ./src;
                         filter = path: type: !hasSuffix ".c" path; })
      (cleanSourceWith { src = cleanSource ./.;
                         filter = path: type: baseNameOf path != "src"; })
  }")'
)"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./foo.bar
./README.md
./src
./src/bar.o
EOF
) || die "sources.union: rhs filter doesn't influence lhs files"

dir="$(nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
  setName "anna" (cleanSource ./.)
}")')"
echo $dir | grep -- -anna >/dev/null || die "setName"

echo >&2 tests ok
