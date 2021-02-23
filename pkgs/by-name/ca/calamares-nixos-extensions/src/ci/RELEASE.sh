#! /bin/sh
#
#   SPDX-FileCopyrightText: 2018 Adriaan de Groot <groot@kde.org>
#   SPDX-License-Identifier: BSD-2-Clause
#
### USAGE
#
# Release script for Calamares-Extensions
#
# NOTE: this is largely a copy of the release script for Calamares,
#       with not-applicable parts (such as translation-freeze) either
#       commented-out, or skipped with if(false).
# NOTE: this script contains Linuxisms (in particular, expects GNU mktemp(1))
#
# This attempts to perform the different steps of the RELEASE.md
# document automatically. It's not tested on other machines or
# setups other than [ade]'s development VM.
#
# Assumes that the version in CMakeLists.txt has been bumped,
# and that a release of that version is desired.
#
# None of the "update stuff" is done by this script; in preparation
# for the release, you should have already done:
#   * updating the version
#   * pulling translations
#   * updating the language list
#   * switching to the right branch
# The release can fail for various reasons: doesn't build, tests fail,
# or the string freeze has been violated.
#
# You can influence the script a little with these options:
#   * `-B` do not build (before tagging)
#   * `-P` do not package (tag, sign, tarball)
#   * `-T` do not respect string freeze
#   * `-C <args>` set extra arguments to pass to CMake
#
# The build / package settings can be influenced via environment variables:
#   * BUILD_DEFAULT set to `false` to avoid first build with gcc
#   * BUILD_CLANG   set to `false` to avoid second build with clang
#   * BUILD_ONLY    set to `true` to break after building
#
### END USAGE

PROJECT_NAME=calamares-extensions
# Directory to check for
EXPECTED_SOURCEDIR=modules
# If non-empty, set string-freeze to this regardless of -T
FORCE_STRING_FREEZE=false
# Run tests?
MAKE_TEST=false
# (prefix) of the tarball name
TARBALL_PREFIX="$PROJECT_NAME"
# Extra arguments to CMake
CMAKE_ARGS=""

test -d .git || { echo "Not at top-level." ; exit 1 ; }
test -d "$EXPECTED_SOURCEDIR" || { echo "No ${EXPECTED_SOURCEDIR}." ; exit 1 ; }

which cmake > /dev/null 2>&1 || { echo "No cmake(1) available." ; exit 1 ; }

test -z "$BUILD_DEFAULT" && BUILD_DEFAULT=true
test -z "$BUILD_CLANG" && BUILD_CLANG=true
test -z "$BUILD_ONLY" && BUILD_ONLY=false
STRING_FREEZE=true

while getopts "hBPTC:" opt ; do
    case "$opt" in
    h|\?)
        sed -e '1,/USAGE/d' -e '/END.USAGE/,$d' < "$0"
        return 0
        ;;
    B)
        BUILD_DEFAULT=false
        BUILD_CLANG=false
        ;;
    P)
        BUILD_ONLY=true
        ;;
    T)
        STRING_FREEZE=false
        ;;
    C)
        CMAKE_ARGS="$OPTARG"
        ;;
    esac
done
test -n "$FORCE_STRING_FREEZE" && STRING_FREEZE="$FORCE_STRING_FREEZE"

if $STRING_FREEZE ; then
	sh ci/txcheck.sh || { echo "! String freeze failed." ; exit 1 ; }
fi

### Setup
#
#
BUILDDIR=$(mktemp -d --suffix=-build --tmpdir=.)

### Build with default compiler
#
#
if test "x$BUILD_DEFAULT" = "xtrue" ; then
    rm -rf "$BUILDDIR"
    mkdir "$BUILDDIR" || { echo "Could not create build directory." ; exit 1 ; }
    ( cd "$BUILDDIR" && cmake .. $CMAKE_ARGS && make -j4 ) || { echo "Could not perform test-build in $BUILDDIR." ; exit 1 ; }
    if $MAKE_TEST ; then
        ( cd "$BUILDDIR" && make test ) || { echo "Tests failed in $BUILDDIR ." ; exit 1 ; }
    fi
fi

### Build with clang
#
#
if test "x$BUILD_CLANG" = "xtrue" ; then
    if which clang++ > /dev/null 2>&1 ; then
        # Do build again with clang
        rm -rf "$BUILDDIR"
        mkdir "$BUILDDIR" || { echo "Could not create build directory." ; exit 1 ; }
        ( cd "$BUILDDIR" && CC=clang CXX=clang++ cmake .. $CMAKE_ARGS && make -j4 ) || { echo "Could not perform test-build in $BUILDDIR." ; exit 1 ; }
        if $MAKE_TEST ; then
            ( cd "$BUILDDIR" && make test ) || { echo "Tests failed in $BUILDDIR (clang)." ; exit 1 ; }
        fi
    fi
fi

if test "x$BUILD_ONLY" = "xtrue" ; then
    echo "Builds completed, release stopped. Build remains in $BUILDDIR ."
    exit 1
fi

if test -f "$BUILDDIR/CMakeCache.txt" ; then
    # Some build has created it, so that's good
    :
else
    # Presumably -B was given; just do the cmake part
    rm -rf "$BUILDDIR"
    mkdir "$BUILDDIR" || { echo "Could not create build directory." ; exit 1 ; }
    ( cd "$BUILDDIR" && cmake .. $CMAKE_ARGS ) || { echo "Could not run cmake in $BUILDDIR ." ; exit 1 ; }
fi

### Get version number for this release
#
#
V=$( cd "$BUILDDIR" && make show-version | grep ^CALAMARES_VERSION | sed s/^[A-Z_]*=// )
test -n "$V" || { echo "Could not obtain version in $BUILDDIR ." ; exit 1 ; }

### Create signed tag
#
# This is the signing key ID associated with the GitHub account adriaandegroot,
# which is used to create all "verified" tags in the Calamares repo.
KEY_ID="CFDDC96F12B1915C"
git tag -u "$KEY_ID" -m "Release v$V" "v$V" || { echo "Could not sign tag v$V." ; exit 1 ; }

### Create the tarball
#
#
TAR_V="$TARBALL_PREFIX-$V"
TAR_FILE="$TAR_V.tar.gz"
git archive -o "$TAR_FILE" --prefix "$TAR_V/" "v$V" || { echo "Could not create tarball." ; exit 1 ; }
test -f "$TAR_FILE" || { echo "Tarball was not created." ; exit 1 ; }
SHA256=$(sha256sum "$TAR_FILE" | cut -d" " -f1)

### Build the tarball
#
#
D=$(date +%Y%m%d-%H%M%S)
TMPDIR=$(mktemp -d --suffix="-calamares-$D")
test -d "$TMPDIR" || { echo "Could not create tarball-build directory." ; exit 1 ; }
tar xzf "$TAR_FILE" -C "$TMPDIR" || { echo "Could not unpack tarball." ; exit 1 ; }
test -d "$TMPDIR/$TAR_V" || { echo "Tarball did not contain source directory." ; exit 1 ; }
( cd "$TMPDIR/$TAR_V" && cmake . $CMAKE_ARGS && make -j4 ) || { echo "Tarball build failed in $TMPDIR ." ; exit 1 ; }
if $MAKE_TEST ; then
    ( cd "$TMPDIR/$TAR_V" && make test ) || { echo "Tarball test failed in $TMPDIR ." ; exit 1 ; }
fi

### Cleanup
#
rm -rf "$BUILDDIR"  # From test-builds
rm -rf "$TMPDIR"  # From tarball

### Print subsequent instructions
#
#
cat <<EOF
# Next steps for this release:
  git push origin v$V
  gpg -s -u $KEY_ID --detach --armor $TAR_FILE  # Sign the tarball
  # Upload tarball $TAR_FILE and the signature $TAR_FILE.asc
  # Announce via https://github.com/calamares/$PROJECT_NAME/releases/new
  # SHA256: $SHA256
EOF

exit 0
