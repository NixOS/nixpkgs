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
  sources.filter (path: type: ! hasSuffix ".bar" path) { outPath = ./.; fetcherLikeMetadata = "included"; }
}")')"
(cd $dir; find) | sort -f | diff -U10 - <(cat <<EOF
.
./module.o
./README.md
EOF
) || die "paths with metadata are also sources"

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
    extend (empty ./.) [ ./src ]
  }")')"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./src
./src/bar.c
./src/bar.o
EOF
) || die "sources.extend: basic"

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    extend (empty ./.) [ (cleanSource ./src) ]
  }")')"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./src
./src/bar.c
EOF
) || die "sources.extend: filtered rhs"


dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    extend
      (cleanSourceWith { src = cleanSource ./.;
                         filter = path: type: baseNameOf path != "src"; })
      [ ./src ]
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
) || die "sources.extend: filtered lhs"

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    extend
      (cleanSourceWith { src = cleanSource ./.;
                         filter = path: type: baseNameOf path != "src"; })
      [ (cleanSourceWith { src = ./src;
                         filter = path: type: !hasSuffix ".c" path; }) ]
  }")'
)"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./foo.bar
./README.md
./src
./src/bar.o
EOF
) || die "sources.extend: lhs filter doesn't influence rhs files"


dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    extend
      (cleanSourceWith { src = reparent ./. ./src;
                         filter = path: type: !hasSuffix ".c" path; })
      [ (cleanSourceWith { src = cleanSource ./.;
                         filter = path: type: baseNameOf path != "src"; }) ]
  }")'
)"
(cd "$dir"; find .) | sort -f | diff -U10 - <(cat <<EOF
.
./foo.bar
./README.md
./src
./src/bar.o
EOF
) || die "sources.extend: rhs filter doesn't influence lhs files"

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    extend
      (cleanSource ./src)
      [ ./README.md ]
  }")'
)"
(cd "$dir" && find ..) | sort -f | diff -U10 - <(cat <<EOF
..
../README.md
../src
../src/bar.c
EOF
) || die "sources.extend: can add a file to parent directory"


dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    pointAt ./. (
      extend
        (cleanSource ./src)
        [ ./README.md ]
    )
  }")'
)"
(cd "$dir" && find .) | sort -f | diff -U10 - <(cat <<EOF
.
./README.md
./src
./src/bar.c
EOF
) || die "sources.pointAt can change to parent directory"

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    pointAt ./src (
      extend
        ./README.md
        [ (cleanSource ./src) ]
    )
  }")'
)"
(cd "$dir" && find ..) | sort -f | diff -U10 - <(cat <<EOF
..
../README.md
../src
../src/bar.c
EOF
) || die "sources.pointAt can change to subdirectory"


(
  (
    nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
      pointAt ./src (
        extend
          ./README.md
          [ ./foo.bar ]
      )
      }")' || true
  ) 2>&1 | grep 'is not actually included in the source. Potential causes include an incorrect path, incorrect filter function or a forgotten sources.extend call.' >/dev/null
) || die "sources.pointAt does not cause accidental inclusion"

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    cutAt ./src (
      extend
        ./README.md
        [ (cleanSource ./src) ]
    )
  }")'
)"
(cd "$dir" && find .) | sort -f | diff -U10 - <(cat <<EOF
.
./bar.c
EOF
) || die "sources.cutAt only includes part of the tree"
(echo "$dir" | grep -- '-source$' >/dev/null) || die "sources.cutAt produces a plain store path; not a subpath of a store path"

dir="$(
  nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
    extend
      (cleanSource ./src)
      [ ./README.md
        ./foo.bar
      ]
  }")'
)"
(cd "$dir" && find ..) | sort -f | diff -U10 - <(cat <<EOF
..
../foo.bar
../README.md
../src
../src/bar.c
EOF
) || die "sources.extend: can add a file to parent directory"

dir="$(nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
  setName "anna" (cleanSource ./.)
}")')"
echo $dir | grep -- -anna >/dev/null || die "setName"

{
  (
    nix eval --raw '(with import <nixpkgs/lib>; with sources; "${
      extend ./. [ ./does-not-exist ]
    }")' || true
  ) 2>&1 | grep 'error: Path does not exist while attempting to construct a source.' >/dev/null
} || die "non-existing paths are an error, even when used lazily in, say, extend's list argument."
echo $dir | grep -- -anna >/dev/null || die "setName"

echo >&2 tests ok
