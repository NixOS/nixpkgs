#!/usr/bin/env bash
# shellcheck disable=SC2016

# Tests lib.fileset
# Run:
# [nixpkgs]$ lib/fileset/tests.sh
# or:
# [nixpkgs]$ nix-build lib/tests/release.nix

set -euo pipefail
shopt -s inherit_errexit dotglob

die() {
    # The second to last entry contains the line number of the top-level caller
    lineIndex=$(( ${#BASH_LINENO[@]} - 2 ))
    echo >&2 -e "test case at ${BASH_SOURCE[0]}:${BASH_LINENO[$lineIndex]} failed:" "$@"
    exit 1
}

if test -n "${TEST_LIB:-}"; then
  NIX_PATH=nixpkgs="$(dirname "$TEST_LIB")"
else
  NIX_PATH=nixpkgs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
fi
export NIX_PATH

tmp="$(mktemp -d)"
clean_up() {
    rm -rf "$tmp"
}
trap clean_up EXIT SIGINT SIGTERM
work="$tmp/work"
mkdir "$work"
cd "$work"

# Crudely unquotes a JSON string by just taking everything between the first and the second quote.
# We're only using this for resulting /nix/store paths, which can't contain " anyways,
# nor can they contain any other characters that would need to be escaped specially in JSON
# This way we don't need to add a dependency on e.g. jq
crudeUnquoteJSON() {
    cut -d \" -f2
}

prefixExpression='let
  lib = import <nixpkgs/lib>;
  internal = import <nixpkgs/lib/fileset/internal.nix> {
    inherit lib;
  };
in
with lib;
with internal;
with lib.fileset;'

# Check that two nix expression successfully evaluate to the same value.
# The expressions have `lib.fileset` in scope.
# Usage: expectEqual NIX NIX
expectEqual() {
    local actualExpr=$1
    local expectedExpr=$2
    if ! actualResult=$(nix-instantiate --eval --strict --show-trace \
        --expr "$prefixExpression ($actualExpr)"); then
        die "$actualExpr failed to evaluate, but it was expected to succeed"
    fi
    if ! expectedResult=$(nix-instantiate --eval --strict --show-trace \
        --expr "$prefixExpression ($expectedExpr)"); then
        die "$expectedExpr failed to evaluate, but it was expected to succeed"
    fi

    if [[ "$actualResult" != "$expectedResult" ]]; then
        die "$actualExpr should have evaluated to $expectedExpr:\n$expectedResult\n\nbut it evaluated to\n$actualResult"
    fi
}

# Check that a nix expression evaluates successfully to a store path and returns it (without quotes).
# The expression has `lib.fileset` in scope.
# Usage: expectStorePath NIX
expectStorePath() {
    local expr=$1
    if ! result=$(nix-instantiate --eval --strict --json --read-write-mode --show-trace \
        --expr "$prefixExpression ($expr)"); then
        die "$expr failed to evaluate, but it was expected to succeed"
    fi
    # This is safe because we assume to get back a store path in a string
    crudeUnquoteJSON <<< "$result"
}

# Check that a nix expression fails to evaluate (strictly, coercing to json, read-write-mode).
# And check the received stderr against a regex
# The expression has `lib.fileset` in scope.
# Usage: expectFailure NIX REGEX
expectFailure() {
    local expr=$1
    local expectedErrorRegex=$2
    if result=$(nix-instantiate --eval --strict --json --read-write-mode --show-trace 2>"$tmp/stderr" \
        --expr "$prefixExpression $expr"); then
        die "$expr evaluated successfully to $result, but it was expected to fail"
    fi
    stderr=$(<"$tmp/stderr")
    if [[ ! "$stderr" =~ $expectedErrorRegex ]]; then
        die "$expr should have errored with this regex pattern:\n\n$expectedErrorRegex\n\nbut this was the actual error:\n\n$stderr"
    fi
}

# We conditionally use inotifywait in checkFileset.
# Check early whether it's available
# TODO: Darwin support, though not crucial since we have Linux CI
if type inotifywait 2>/dev/null >/dev/null; then
    canMonitorFiles=1
else
    echo "Warning: Not checking that excluded files don't get accessed since inotifywait is not available" >&2
    canMonitorFiles=
fi

# Check whether a file set includes/excludes declared paths as expected, usage:
#
# tree=(
#   [a/b] =1  # Declare that file       a/b should exist and expect it to be included in the store path
#   [c/a] =   # Declare that file       c/a should exist and expect it to be excluded in the store path
#   [c/d/]=   # Declare that directory c/d/ should exist and expect it to be excluded in the store path
# )
# checkFileset './a' # Pass the fileset as the argument
declare -A tree
checkFileset() (
    # New subshell so that we can have a separate trap handler, see `trap` below
    local fileset=$1

    # Process the tree into separate arrays for included paths, excluded paths and excluded files.
    local -a included=()
    local -a excluded=()
    local -a excludedFiles=()
    # Track which paths need to be created
    local -a dirsToCreate=()
    local -a filesToCreate=()
    for p in "${!tree[@]}"; do
        # If keys end with a `/` we treat them as directories, otherwise files
        if [[ "$p" =~ /$ ]]; then
            dirsToCreate+=("$p")
            isFile=
        else
            filesToCreate+=("$p")
            isFile=1
        fi
        case "${tree[$p]}" in
            1)
                included+=("$p")
                ;;
            0)
                excluded+=("$p")
                if [[ -n "$isFile" ]]; then
                    excludedFiles+=("$p")
                fi
                ;;
            *)
                die "Unsupported tree value: ${tree[$p]}"
        esac
    done

    # Create all the necessary paths.
    # This is done with only a fixed number of processes,
    # in order to not be too slow
    # Though this does mean we're a bit limited with how many files can be created
    if (( ${#dirsToCreate[@]} != 0 )); then
        mkdir -p "${dirsToCreate[@]}"
    fi
    if (( ${#filesToCreate[@]} != 0 )); then
        readarray -d '' -t parentsToCreate < <(dirname -z "${filesToCreate[@]}")
        mkdir -p "${parentsToCreate[@]}"
        touch "${filesToCreate[@]}"
    fi

    # Start inotifywait in the background to monitor all excluded files (if any)
    if [[ -n "$canMonitorFiles" ]] && (( "${#excludedFiles[@]}" != 0 )); then
        coproc watcher {
            # inotifywait outputs a string on stderr when ready
            # Redirect it to stdout so we can access it from the coproc's stdout fd
            # exec so that the coprocess is inotify itself, making the kill below work correctly
            # See below why we listen to both open and delete_self events
            exec inotifywait --format='%e %w' --event open,delete_self --monitor "${excludedFiles[@]}" 2>&1
        }
        # This will trigger when this subshell exits, no matter if successful or not
        # After exiting the subshell, the parent shell will continue executing
        # shellcheck disable=SC2154
        trap 'kill "${watcher_PID}"' exit

        # Synchronously wait until inotifywait is ready
        while read -r -u "${watcher[0]}" line && [[ "$line" != "Watches established." ]]; do
            :
        done
    fi

    # Call toSource with the fileset, triggering open events for all files that are added to the store
    expression="toSource { root = ./.; fileset = $fileset; }"
    storePath=$(expectStorePath "$expression")

    # Remove all files immediately after, triggering delete_self events for all of them
    rm -rf -- *

    # Only check for the inotify events if we actually started inotify earlier
    if [[ -v watcher ]]; then
        # Get the first event
        read -r -u "${watcher[0]}" event file

        # There's only these two possible event timelines:
        # - open, ..., open, delete_self, ..., delete_self: If some excluded files were read
        # - delete_self, ..., delete_self: If no excluded files were read
        # So by looking at the first event we can figure out which one it is!
        case "$event" in
            OPEN)
                die "$expression opened excluded file $file when it shouldn't have"
                ;;
            DELETE_SELF)
                # Expected events
                ;;
            *)
                die "Unexpected event type '$event' on file $file that should be excluded"
                ;;
        esac
    fi

    # For each path that should be included, make sure it does occur in the resulting store path
    for p in "${included[@]}"; do
        if [[ ! -e "$storePath/$p" ]]; then
            die "$expression doesn't include path $p when it should have"
        fi
    done

    # For each path that should be excluded, make sure it doesn't occur in the resulting store path
    for p in "${excluded[@]}"; do
        if [[ -e "$storePath/$p" ]]; then
            die "$expression included path $p when it shouldn't have"
        fi
    done
)


#### Error messages #####

# Absolute paths in strings cannot be passed as `root`
expectFailure 'toSource { root = "/nix/store/foobar"; fileset = ./.; }' 'lib.fileset.toSource: `root` \("/nix/store/foobar"\) is a string-like value, but it should be a path instead.
\s*Paths in strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.'

# Only paths are accepted as `root`
expectFailure 'toSource { root = 10; fileset = ./.; }' 'lib.fileset.toSource: `root` is of type int, but it should be a path instead.'

# Different filesystem roots in root and fileset are not supported
mkdir -p {foo,bar}/mock-root
expectFailure 'with ((import <nixpkgs/lib>).extend (import <nixpkgs/lib/fileset/mock-splitRoot.nix>)).fileset;
  toSource { root = ./foo/mock-root; fileset = ./bar/mock-root; }
' 'lib.fileset.toSource: Filesystem roots are not the same for `fileset` and `root` \("'"$work"'/foo/mock-root"\):
\s*`root`: root "'"$work"'/foo/mock-root"
\s*`fileset`: root "'"$work"'/bar/mock-root"
\s*Different roots are not supported.'
rm -rf *

# `root` needs to exist
expectFailure 'toSource { root = ./a; fileset = ./.; }' 'lib.fileset.toSource: `root` \('"$work"'/a\) does not exist.'

# `root` needs to be a file
touch a
expectFailure 'toSource { root = ./a; fileset = ./a; }' 'lib.fileset.toSource: `root` \('"$work"'/a\) is a file, but it should be a directory instead. Potential solutions:
\s*- If you want to import the file into the store _without_ a containing directory, use string interpolation or `builtins.path` instead of this function.
\s*- If you want to import the file into the store _with_ a containing directory, set `root` to the containing directory, such as '"$work"', and set `fileset` to the file path.'
rm -rf *

# The fileset argument should be evaluated, even if the directory is empty
expectFailure 'toSource { root = ./.; fileset = abort "This should be evaluated"; }' 'evaluation aborted with the following error message: '\''This should be evaluated'\'

# Only paths under `root` should be able to influence the result
mkdir a
expectFailure 'toSource { root = ./a; fileset = ./.; }' 'lib.fileset.toSource: `fileset` could contain files in '"$work"', which is not under the `root` \('"$work"'/a\). Potential solutions:
\s*- Set `root` to '"$work"' or any directory higher up. This changes the layout of the resulting store path.
\s*- Set `fileset` to a file set that cannot contain files outside the `root` \('"$work"'/a\). This could change the files included in the result.'
rm -rf *

# Path coercion only works for paths
expectFailure 'toSource { root = ./.; fileset = 10; }' 'lib.fileset.toSource: `fileset` is of type int, but it should be a path instead.'
expectFailure 'toSource { root = ./.; fileset = "/some/path"; }' 'lib.fileset.toSource: `fileset` \("/some/path"\) is a string-like value, but it should be a path instead.
\s*Paths represented as strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.'

# Path coercion errors for non-existent paths
expectFailure 'toSource { root = ./.; fileset = ./a; }' 'lib.fileset.toSource: `fileset` \('"$work"'/a\) does not exist.'

# File sets cannot be evaluated directly
expectFailure 'union ./. ./.' 'lib.fileset: Directly evaluating a file set is not supported. Use `lib.fileset.toSource` to turn it into a usable source instead.'
expectFailure '_emptyWithoutBase' 'lib.fileset: Directly evaluating a file set is not supported. Use `lib.fileset.toSource` to turn it into a usable source instead.'

# Past versions of the internal representation are supported
expectEqual '_coerce "<tests>: value" { _type = "fileset"; _internalVersion = 0; _internalBase = ./.; }' \
    '{ _internalBase = ./.; _internalBaseComponents = path.subpath.components (path.splitRoot ./.).subpath; _internalBaseRoot = /.; _internalIsEmptyWithoutBase = false; _internalVersion = 3; _type = "fileset"; }'
expectEqual '_coerce "<tests>: value" { _type = "fileset"; _internalVersion = 1; }' \
    '{ _type = "fileset"; _internalIsEmptyWithoutBase = false; _internalVersion = 3; }'
expectEqual '_coerce "<tests>: value" { _type = "fileset"; _internalVersion = 2; }' \
    '{ _type = "fileset"; _internalIsEmptyWithoutBase = false; _internalVersion = 3; }'

# Future versions of the internal representation are unsupported
expectFailure '_coerce "<tests>: value" { _type = "fileset"; _internalVersion = 4; }' '<tests>: value is a file set created from a future version of the file set library with a different internal representation:
\s*- Internal version of the file set: 4
\s*- Internal version of the library: 3
\s*Make sure to update your Nixpkgs to have a newer version of `lib.fileset`.'

# _create followed by _coerce should give the inputs back without any validation
expectEqual '{
  inherit (_coerce "<test>" (_create ./. "directory"))
    _internalVersion _internalBase _internalTree;
}' '{ _internalBase = ./.; _internalTree = "directory"; _internalVersion = 3; }'

#### Resulting store path ####

# The store path name should be "source"
expectEqual 'toSource { root = ./.; fileset = ./.; }' 'sources.cleanSourceWith { name = "source"; src = ./.; }'

# We should be able to import an empty directory and end up with an empty result
tree=(
)
checkFileset './.'

# The empty value without a base should also result in an empty result
tree=(
    [a]=0
)
checkFileset '_emptyWithoutBase'

# Directories recursively containing no files are not included
tree=(
    [e/]=0
    [d/e/]=0
    [d/d/e/]=0
    [d/d/f]=1
    [d/f]=1
    [f]=1
)
checkFileset './.'

# Check trees that could cause a naïve string prefix checking implementation to fail
tree=(
    [a]=0
    [ab/x]=0
    [ab/xy]=1
    [ab/xyz]=0
    [abc]=0
)
checkFileset './ab/xy'

# Check path coercion examples in ../../doc/functions/fileset.section.md
tree=(
    [a/x]=1
    [a/b/y]=1
    [c/]=0
    [c/d/]=0
)
checkFileset './.'

tree=(
    [a/x]=1
    [a/b/y]=1
    [c/]=0
    [c/d/]=0
)
checkFileset './a'

tree=(
    [a/x]=1
    [a/b/y]=0
    [c/]=0
    [c/d/]=0
)
checkFileset './a/x'

tree=(
    [a/x]=0
    [a/b/y]=1
    [c/]=0
    [c/d/]=0
)
checkFileset './a/b'

tree=(
    [a/x]=0
    [a/b/y]=0
    [c/]=0
    [c/d/]=0
)
checkFileset './c'

# Test the source filter for the somewhat special case of files in the filesystem root
# We can't easily test this with the above functions because we can't write to the filesystem root and we don't want to make any assumptions which files are there in the sandbox
expectEqual '_toSourceFilter (_create /. null) "/foo" ""' 'false'
expectEqual '_toSourceFilter (_create /. { foo = "regular"; }) "/foo" ""' 'true'
expectEqual '_toSourceFilter (_create /. { foo = null; }) "/foo" ""' 'false'


## lib.fileset.union, lib.fileset.unions


# Different filesystem roots in root and fileset are not supported
mkdir -p {foo,bar}/mock-root
expectFailure 'with ((import <nixpkgs/lib>).extend (import <nixpkgs/lib/fileset/mock-splitRoot.nix>)).fileset;
  toSource { root = ./.; fileset = union ./foo/mock-root ./bar/mock-root; }
' 'lib.fileset.union: Filesystem roots are not the same:
\s*first argument: root "'"$work"'/foo/mock-root"
\s*second argument: root "'"$work"'/bar/mock-root"
\s*Different roots are not supported.'

expectFailure 'with ((import <nixpkgs/lib>).extend (import <nixpkgs/lib/fileset/mock-splitRoot.nix>)).fileset;
  toSource { root = ./.; fileset = unions [ ./foo/mock-root ./bar/mock-root ]; }
' 'lib.fileset.unions: Filesystem roots are not the same:
\s*element 0: root "'"$work"'/foo/mock-root"
\s*element 1: root "'"$work"'/bar/mock-root"
\s*Different roots are not supported.'
rm -rf *

# Coercion errors show the correct context
expectFailure 'toSource { root = ./.; fileset = union ./a ./.; }' 'lib.fileset.union: first argument \('"$work"'/a\) does not exist.'
expectFailure 'toSource { root = ./.; fileset = union ./. ./b; }' 'lib.fileset.union: second argument \('"$work"'/b\) does not exist.'
expectFailure 'toSource { root = ./.; fileset = unions [ ./a ./. ]; }' 'lib.fileset.unions: element 0 \('"$work"'/a\) does not exist.'
expectFailure 'toSource { root = ./.; fileset = unions [ ./. ./b ]; }' 'lib.fileset.unions: element 1 \('"$work"'/b\) does not exist.'

# unions needs a list
expectFailure 'toSource { root = ./.; fileset = unions null; }' 'lib.fileset.unions: Expected argument to be a list, but got a null.'

# The tree of later arguments should not be evaluated if a former argument already includes all files
tree=()
checkFileset 'union ./. (_create ./. (abort "This should not be used!"))'
checkFileset 'unions [ ./. (_create ./. (abort "This should not be used!")) ]'

# unions doesn't include any files for an empty list or only empty values without a base
tree=(
    [x]=0
    [y/z]=0
)
checkFileset 'unions [ ]'
checkFileset 'unions [ _emptyWithoutBase ]'
checkFileset 'unions [ _emptyWithoutBase _emptyWithoutBase ]'
checkFileset 'union _emptyWithoutBase _emptyWithoutBase'

# The empty value without a base is the left and right identity of union
tree=(
    [x]=1
    [y/z]=0
)
checkFileset 'union ./x _emptyWithoutBase'
checkFileset 'union _emptyWithoutBase ./x'

# union doesn't include files that weren't specified
tree=(
    [x]=1
    [y]=1
    [z]=0
)
checkFileset 'union ./x ./y'
checkFileset 'unions [ ./x ./y ]'

# Also for directories
tree=(
    [x/a]=1
    [x/b]=1
    [y/a]=1
    [y/b]=1
    [z/a]=0
    [z/b]=0
)
checkFileset 'union ./x ./y'
checkFileset 'unions [ ./x ./y ]'

# And for very specific paths
tree=(
    [x/a]=1
    [x/b]=0
    [y/a]=0
    [y/b]=1
    [z/a]=0
    [z/b]=0
)
checkFileset 'union ./x/a ./y/b'
checkFileset 'unions [ ./x/a ./y/b ]'

# unions or chained union's can include more paths
tree=(
    [x/a]=1
    [x/b]=1
    [y/a]=1
    [y/b]=0
    [z/a]=0
    [z/b]=1
)
checkFileset 'unions [ ./x/a ./x/b ./y/a ./z/b ]'
checkFileset 'union (union ./x/a ./x/b) (union ./y/a ./z/b)'
checkFileset 'union (union (union ./x/a ./x/b) ./y/a) ./z/b'

# unions should not stack overflow, even if many elements are passed
tree=()
for i in $(seq 1000); do
    tree[$i/a]=1
    tree[$i/b]=0
done
# This is actually really hard to test:
# A lot of files would be needed to cause a stack overflow.
# And while we could limit the maximum stack size using `ulimit -s`,
# that turns out to not be very deterministic: https://github.com/NixOS/nixpkgs/pull/256417#discussion_r1339396686.
# Meanwhile, the test infra here is not the fastest, creating 10000 would be too slow.
# So, just using 1000 files for now.
checkFileset 'unions (mapAttrsToList (name: _: ./. + "/${name}/a") (builtins.readDir ./.))'

# TODO: Once we have combinators and a property testing library, derive property tests from https://en.wikipedia.org/wiki/Algebra_of_sets

echo >&2 tests ok
