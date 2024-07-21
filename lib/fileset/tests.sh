#!/usr/bin/env bash
# shellcheck disable=SC2016
# shellcheck disable=SC2317
# shellcheck disable=SC2192

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

prefixExpression='
  let
    lib = import <nixpkgs/lib>;
    internal = import <nixpkgs/lib/fileset/internal.nix> {
      inherit lib;
    };
  in
  with lib;
  with internal;
  with lib.fileset;
'

# Check that two nix expression successfully evaluate to the same value.
# The expressions have `lib.fileset` in scope.
# Usage: expectEqual NIX NIX
expectEqual() {
    local actualExpr=$1
    local expectedExpr=$2
    if actualResult=$(nix-instantiate --eval --strict --show-trace 2>"$tmp"/actualStderr \
        --expr "$prefixExpression ($actualExpr)"); then
        actualExitCode=$?
    else
        actualExitCode=$?
    fi
    actualStderr=$(< "$tmp"/actualStderr)

    if expectedResult=$(nix-instantiate --eval --strict --show-trace 2>"$tmp"/expectedStderr \
        --expr "$prefixExpression ($expectedExpr)"); then
        expectedExitCode=$?
    else
        expectedExitCode=$?
    fi
    expectedStderr=$(< "$tmp"/expectedStderr)

    if [[ "$actualExitCode" != "$expectedExitCode" ]]; then
        echo "$actualStderr" >&2
        echo "$actualResult" >&2
        die "$actualExpr should have exited with $expectedExitCode, but it exited with $actualExitCode"
    fi

    if [[ "$actualResult" != "$expectedResult" ]]; then
        die "$actualExpr should have evaluated to $expectedExpr:\n$expectedResult\n\nbut it evaluated to\n$actualResult"
    fi

    if [[ "$actualStderr" != "$expectedStderr" ]]; then
        die "$actualExpr should have had this on stderr:\n$expectedStderr\n\nbut it was\n$actualStderr"
    fi
}

# Check that a nix expression evaluates successfully to a store path and returns it (without quotes).
# The expression has `lib.fileset` in scope.
# Usage: expectStorePath NIX
expectStorePath() {
    local expr=$1
    if ! result=$(nix-instantiate --eval --strict --json --read-write-mode --show-trace 2>"$tmp"/stderr \
        --expr "$prefixExpression ($expr)"); then
        cat "$tmp/stderr" >&2
        die "$expr failed to evaluate, but it was expected to succeed"
    fi
    # This is safe because we assume to get back a store path in a string
    crudeUnquoteJSON <<< "$result"
}

# Check that a nix expression fails to evaluate (strictly, read-write-mode).
# And check the received stderr against a regex
# The expression has `lib.fileset` in scope.
# Usage: expectFailure NIX REGEX
expectFailure() {
    local expr=$1
    local expectedErrorRegex=$2
    if result=$(nix-instantiate --eval --strict --read-write-mode --show-trace 2>"$tmp/stderr" \
        --expr "$prefixExpression $expr"); then
        die "$expr evaluated successfully to $result, but it was expected to fail"
    fi
    stderr=$(<"$tmp/stderr")
    if [[ ! "$stderr" =~ $expectedErrorRegex ]]; then
        die "$expr should have errored with this regex pattern:\n\n$expectedErrorRegex\n\nbut this was the actual error:\n\n$stderr"
    fi
}

# Check that the traces of a Nix expression are as expected when evaluated.
# The expression has `lib.fileset` in scope.
# Usage: expectTrace NIX STR
expectTrace() {
    local expr=$1
    local expectedTrace=$2

    nix-instantiate --eval --show-trace >/dev/null 2>"$tmp"/stderrTrace \
        --expr "$prefixExpression trace ($expr)" || true

    actualTrace=$(sed -n 's/^trace: //p' "$tmp/stderrTrace")

    nix-instantiate --eval --show-trace >/dev/null 2>"$tmp"/stderrTraceVal \
        --expr "$prefixExpression traceVal ($expr)" || true

    actualTraceVal=$(sed -n 's/^trace: //p' "$tmp/stderrTraceVal")

    # Test that traceVal returns the same trace as trace
    if [[ "$actualTrace" != "$actualTraceVal" ]]; then
        cat "$tmp"/stderrTrace >&2
        die "$expr traced this for lib.fileset.trace:\n\n$actualTrace\n\nand something different for lib.fileset.traceVal:\n\n$actualTraceVal"
    fi

    if [[ "$actualTrace" != "$expectedTrace" ]]; then
        cat "$tmp"/stderrTrace >&2
        die "$expr should have traced this:\n\n$expectedTrace\n\nbut this was actually traced:\n\n$actualTrace"
    fi
}

# We conditionally use inotifywait in withFileMonitor.
# Check early whether it's available
# TODO: Darwin support, though not crucial since we have Linux CI
if type inotifywait 2>/dev/null >/dev/null; then
    canMonitor=1
else
    echo "Warning: Cannot check for paths not getting read since the inotifywait command (from the inotify-tools package) is not available" >&2
    canMonitor=
fi

# Run a function while monitoring that it doesn't read certain paths
# Usage: withFileMonitor FUNNAME PATH...
# - FUNNAME should be a bash function that:
#   - Performs some operation that should not read some paths
#   - Delete the paths it shouldn't read without triggering any open events
# - PATH... are the paths that should not get read
#
# This function outputs the same as FUNNAME
withFileMonitor() {
    local funName=$1
    shift

    # If we can't monitor files or have none to monitor, just run the function directly
    if [[ -z "$canMonitor" ]] || (( "$#" == 0 )); then
        "$funName"
    else

        # Use a subshell to start the coprocess in and use a trap to kill it when exiting the subshell
        (
            # Assigned by coproc, makes shellcheck happy
            local watcher watcher_PID

            # Start inotifywait in the background to monitor all excluded paths
            coproc watcher {
                # inotifywait outputs a string on stderr when ready
                # Redirect it to stdout so we can access it from the coproc's stdout fd
                # exec so that the coprocess is inotify itself, making the kill below work correctly
                # See below why we listen to both open and delete_self events
                exec inotifywait --format='%e %w' --event open,delete_self --monitor "$@" 2>&1
            }

            # This will trigger when this subshell exits, no matter if successful or not
            # After exiting the subshell, the parent shell will continue executing
            trap 'kill "${watcher_PID}"' exit

            # Synchronously wait until inotifywait is ready
            while read -r -u "${watcher[0]}" line && [[ "$line" != "Watches established." ]]; do
                :
            done

            # Call the function that should not read the given paths and delete them afterwards
            "$funName"

            # Get the first event
            read -r -u "${watcher[0]}" event file

            # With funName potentially reading files first before deleting them,
            # there's only these two possible event timelines:
            # - open*, ..., open*, delete_self, ..., delete_self: If some excluded paths were read
            # - delete_self, ..., delete_self: If no excluded paths were read
            # So by looking at the first event we can figure out which one it is!
            # This also means we don't have to wait to collect all events.
            case "$event" in
                OPEN*)
                    die "$funName opened excluded file $file when it shouldn't have"
                    ;;
                DELETE_SELF)
                    # Expected events
                    ;;
                *)
                    die "During $funName, Unexpected event type '$event' on file $file that should be excluded"
                    ;;
            esac
        )
    fi
}


# Create the tree structure declared in the tree variable, usage:
#
# tree=(
#   [a/b] =   # Declare that file       a/b should exist
#   [c/a] =   # Declare that file       c/a should exist
#   [c/d/]=   # Declare that directory c/d/ should exist
# )
# createTree
declare -A tree
createTree() {
    # Track which paths need to be created
    local -a dirsToCreate=()
    local -a filesToCreate=()
    for p in "${!tree[@]}"; do
        # If keys end with a `/` we treat them as directories, otherwise files
        if [[ "$p" =~ /$ ]]; then
            dirsToCreate+=("$p")
        else
            filesToCreate+=("$p")
        fi
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
}

# Check whether a file set includes/excludes declared paths as expected, usage:
#
# tree=(
#   [a/b] =1  # Declare that file       a/b should exist and expect it to be included in the store path
#   [c/a] =   # Declare that file       c/a should exist and expect it to be excluded in the store path
#   [c/d/]=   # Declare that directory c/d/ should exist and expect it to be excluded in the store path
# )
# checkFileset './a' # Pass the fileset as the argument
checkFileset() {
    local fileset=$1

    # Create the tree
    createTree

    # Process the tree into separate arrays for included paths, excluded paths and excluded files.
    local -a included=()
    local -a includedFiles=()
    local -a excluded=()
    local -a excludedFiles=()
    for p in "${!tree[@]}"; do
        case "${tree[$p]}" in
            1)
                included+=("$p")
                # If keys end with a `/` we treat them as directories, otherwise files
                if [[ ! "$p" =~ /$ ]]; then
                    includedFiles+=("$p")
                fi
                ;;
            0)
                excluded+=("$p")
                if [[ ! "$p" =~ /$ ]]; then
                    excludedFiles+=("$p")
                fi
                ;;
            *)
                die "Unsupported tree value: ${tree[$p]}"
        esac
    done

    # Test that lib.fileset.toList contains exactly the included files.
    # The /#/./ part prefixes each element with `./`
    expectEqual "toList ($fileset)" "sort lessThan [ ${includedFiles[*]/#/./} ]"

    expression="toSource { root = ./.; fileset = $fileset; }"

    # We don't have lambda's in bash unfortunately,
    # so we just define a function instead and then pass its name
    # shellcheck disable=SC2317
    run() {
        # Call toSource with the fileset, triggering open events for all files that are added to the store
        expectStorePath "$expression"
        if (( ${#excludedFiles[@]} != 0 )); then
            rm "${excludedFiles[@]}"
        fi
    }

    # Runs the function while checking that the given excluded files aren't read
    storePath=$(withFileMonitor run "${excludedFiles[@]}")

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

    rm -rf -- *
}


#### Error messages #####

# We're using [[:blank:]] here instead of \s, because only the former is POSIX
# (see https://pubs.opengroup.org/onlinepubs/007908799/xbd/re.html#tag_007_003_005).
# And indeed, Darwin's bash only supports the former

# Absolute paths in strings cannot be passed as `root`
expectFailure 'toSource { root = "/nix/store/foobar"; fileset = ./.; }' 'lib.fileset.toSource: `root` \(/nix/store/foobar\) is a string-like value, but it should be a path instead.
[[:blank:]]*Paths in strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.'

expectFailure 'toSource { root = cleanSourceWith { src = ./.; }; fileset = ./.; }' 'lib.fileset.toSource: `root` is a `lib.sources`-based value, but it should be a path instead.
[[:blank:]]*To use a `lib.sources`-based value, convert it to a file set using `lib.fileset.fromSource` and pass it as `fileset`.
[[:blank:]]*Note that this only works for sources created from paths.'

# Only paths are accepted as `root`
expectFailure 'toSource { root = 10; fileset = ./.; }' 'lib.fileset.toSource: `root` is of type int, but it should be a path instead.'

# Different filesystem roots in root and fileset are not supported
mkdir -p {foo,bar}/mock-root
expectFailure 'with ((import <nixpkgs/lib>).extend (import <nixpkgs/lib/fileset/mock-splitRoot.nix>)).fileset;
  toSource { root = ./foo/mock-root; fileset = ./bar/mock-root; }
' 'lib.fileset.toSource: Filesystem roots are not the same for `fileset` and `root` \('"$work"'/foo/mock-root\):
[[:blank:]]*`root`: Filesystem root is "'"$work"'/foo/mock-root"
[[:blank:]]*`fileset`: Filesystem root is "'"$work"'/bar/mock-root"
[[:blank:]]*Different filesystem roots are not supported.'
rm -rf -- *

# `root` needs to exist
expectFailure 'toSource { root = ./a; fileset = ./.; }' 'lib.fileset.toSource: `root` \('"$work"'/a\) is a path that does not exist.'

# `root` needs to be a file
touch a
expectFailure 'toSource { root = ./a; fileset = ./a; }' 'lib.fileset.toSource: `root` \('"$work"'/a\) is a file, but it should be a directory instead. Potential solutions:
[[:blank:]]*- If you want to import the file into the store _without_ a containing directory, use string interpolation or `builtins.path` instead of this function.
[[:blank:]]*- If you want to import the file into the store _with_ a containing directory, set `root` to the containing directory, such as '"$work"', and set `fileset` to the file path.'
rm -rf -- *

# The fileset argument should be evaluated, even if the directory is empty
expectFailure 'toSource { root = ./.; fileset = abort "This should be evaluated"; }' 'evaluation aborted with the following error message: '\''This should be evaluated'\'

# Only paths under `root` should be able to influence the result
mkdir a
expectFailure 'toSource { root = ./a; fileset = ./.; }' 'lib.fileset.toSource: `fileset` could contain files in '"$work"', which is not under the `root` \('"$work"'/a\). Potential solutions:
[[:blank:]]*- Set `root` to '"$work"' or any directory higher up. This changes the layout of the resulting store path.
[[:blank:]]*- Set `fileset` to a file set that cannot contain files outside the `root` \('"$work"'/a\). This could change the files included in the result.'
rm -rf -- *

# non-regular and non-symlink files cannot be added to the Nix store
mkfifo a
expectFailure 'toSource { root = ./.; fileset = ./a; }' 'lib.fileset.toSource: `fileset` contains a file that cannot be added to the store: '"$work"'/a
[[:blank:]]*This file is neither a regular file nor a symlink, the only file types supported by the Nix store.
[[:blank:]]*Therefore the file set cannot be added to the Nix store as is. Make sure to not include that file to avoid this error.'
rm -rf -- *

# Path coercion only works for paths
expectFailure 'toSource { root = ./.; fileset = 10; }' 'lib.fileset.toSource: `fileset` is of type int, but it should be a file set or a path instead.'
expectFailure 'toSource { root = ./.; fileset = "/some/path"; }' 'lib.fileset.toSource: `fileset` \("/some/path"\) is a string-like value, but it should be a file set or a path instead.
[[:blank:]]*Paths represented as strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.'
expectFailure 'toSource { root = ./.; fileset = cleanSourceWith { src = ./.; }; }' 'lib.fileset.toSource: `fileset` is a `lib.sources`-based value, but it should be a file set or a path instead.
[[:blank:]]*To convert a `lib.sources`-based value to a file set you can use `lib.fileset.fromSource`.
[[:blank:]]*Note that this only works for sources created from paths.'

# Path coercion errors for non-existent paths
expectFailure 'toSource { root = ./.; fileset = ./a; }' 'lib.fileset.toSource: `fileset` \('"$work"'/a\) is a path that does not exist.
[[:blank:]]*To create a file set from a path that may not exist, use `lib.fileset.maybeMissing`.'

# File sets cannot be evaluated directly
expectFailure 'union ./. ./.' 'lib.fileset: Directly evaluating a file set is not supported.
[[:blank:]]*To turn it into a usable source, use `lib.fileset.toSource`.
[[:blank:]]*To pretty-print the contents, use `lib.fileset.trace` or `lib.fileset.traceVal`.'
expectFailure '_emptyWithoutBase' 'lib.fileset: Directly evaluating a file set is not supported.
[[:blank:]]*To turn it into a usable source, use `lib.fileset.toSource`.
[[:blank:]]*To pretty-print the contents, use `lib.fileset.trace` or `lib.fileset.traceVal`.'

# Past versions of the internal representation are supported
expectEqual '_coerce "<tests>: value" { _type = "fileset"; _internalVersion = 0; _internalBase = ./.; }' \
    '{ _internalBase = ./.; _internalBaseComponents = path.subpath.components (path.splitRoot ./.).subpath; _internalBaseRoot = /.; _internalIsEmptyWithoutBase = false; _internalVersion = 3; _type = "fileset"; }'
expectEqual '_coerce "<tests>: value" { _type = "fileset"; _internalVersion = 1; }' \
    '{ _type = "fileset"; _internalIsEmptyWithoutBase = false; _internalVersion = 3; }'
expectEqual '_coerce "<tests>: value" { _type = "fileset"; _internalVersion = 2; }' \
    '{ _type = "fileset"; _internalIsEmptyWithoutBase = false; _internalVersion = 3; }'

# Future versions of the internal representation are unsupported
expectFailure '_coerce "<tests>: value" { _type = "fileset"; _internalVersion = 4; }' '<tests>: value is a file set created from a future version of the file set library with a different internal representation:
[[:blank:]]*- Internal version of the file set: 4
[[:blank:]]*- Internal version of the library: 3
[[:blank:]]*Make sure to update your Nixpkgs to have a newer version of `lib.fileset`.'

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


## lib.fileset.toList
# This function is mainly tested in checkFileset

# The error context for an invalid argument must be correct
expectFailure 'toList null' 'lib.fileset.toList: Argument is of type null, but it should be a file set or a path instead.'

# Works for the empty fileset
expectEqual 'toList _emptyWithoutBase' '[ ]'

# Works on empty paths
expectEqual 'toList ./.' '[ ]'


## lib.fileset.union, lib.fileset.unions


# Different filesystem roots in root and fileset are not supported
mkdir -p {foo,bar}/mock-root
expectFailure 'with ((import <nixpkgs/lib>).extend (import <nixpkgs/lib/fileset/mock-splitRoot.nix>)).fileset;
  toSource { root = ./.; fileset = union ./foo/mock-root ./bar/mock-root; }
' 'lib.fileset.union: Filesystem roots are not the same:
[[:blank:]]*First argument: Filesystem root is "'"$work"'/foo/mock-root"
[[:blank:]]*Second argument: Filesystem root is "'"$work"'/bar/mock-root"
[[:blank:]]*Different filesystem roots are not supported.'

expectFailure 'with ((import <nixpkgs/lib>).extend (import <nixpkgs/lib/fileset/mock-splitRoot.nix>)).fileset;
  toSource { root = ./.; fileset = unions [ ./foo/mock-root ./bar/mock-root ]; }
' 'lib.fileset.unions: Filesystem roots are not the same:
[[:blank:]]*Element 0: Filesystem root is "'"$work"'/foo/mock-root"
[[:blank:]]*Element 1: Filesystem root is "'"$work"'/bar/mock-root"
[[:blank:]]*Different filesystem roots are not supported.'
rm -rf -- *

# Coercion errors show the correct context
expectFailure 'toSource { root = ./.; fileset = union ./a ./.; }' 'lib.fileset.union: First argument \('"$work"'/a\) is a path that does not exist.'
expectFailure 'toSource { root = ./.; fileset = union ./. ./b; }' 'lib.fileset.union: Second argument \('"$work"'/b\) is a path that does not exist.'
expectFailure 'toSource { root = ./.; fileset = unions [ ./a ./. ]; }' 'lib.fileset.unions: Element 0 \('"$work"'/a\) is a path that does not exist.'
expectFailure 'toSource { root = ./.; fileset = unions [ ./. ./b ]; }' 'lib.fileset.unions: Element 1 \('"$work"'/b\) is a path that does not exist.'

# unions needs a list
expectFailure 'toSource { root = ./.; fileset = unions null; }' 'lib.fileset.unions: Argument is of type null, but it should be a list instead.'

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


## lib.fileset.intersection


# Different filesystem roots in root and fileset are not supported
mkdir -p {foo,bar}/mock-root
expectFailure 'with ((import <nixpkgs/lib>).extend (import <nixpkgs/lib/fileset/mock-splitRoot.nix>)).fileset;
  toSource { root = ./.; fileset = intersection ./foo/mock-root ./bar/mock-root; }
' 'lib.fileset.intersection: Filesystem roots are not the same:
[[:blank:]]*First argument: Filesystem root is "'"$work"'/foo/mock-root"
[[:blank:]]*Second argument: Filesystem root is "'"$work"'/bar/mock-root"
[[:blank:]]*Different filesystem roots are not supported.'
rm -rf -- *

# Coercion errors show the correct context
expectFailure 'toSource { root = ./.; fileset = intersection ./a ./.; }' 'lib.fileset.intersection: First argument \('"$work"'/a\) is a path that does not exist.'
expectFailure 'toSource { root = ./.; fileset = intersection ./. ./b; }' 'lib.fileset.intersection: Second argument \('"$work"'/b\) is a path that does not exist.'

# The tree of later arguments should not be evaluated if a former argument already excludes all files
tree=(
    [a]=0
)
checkFileset 'intersection _emptyWithoutBase (_create ./. (abort "This should not be used!"))'
# We don't have any combinators that can explicitly remove files yet, so we need to rely on internal functions to test this for now
checkFileset 'intersection (_create ./. { a = null; }) (_create ./. { a = abort "This should not be used!"; })'

# If either side is empty, the result is empty
tree=(
    [a]=0
)
checkFileset 'intersection _emptyWithoutBase _emptyWithoutBase'
checkFileset 'intersection _emptyWithoutBase (_create ./. null)'
checkFileset 'intersection (_create ./. null) _emptyWithoutBase'
checkFileset 'intersection (_create ./. null) (_create ./. null)'

# If the intersection base paths are not overlapping, the result is empty and has no base path
mkdir a b c
touch {a,b,c}/x
expectEqual 'toSource { root = ./c; fileset = intersection ./a ./b; }' 'toSource { root = ./c; fileset = _emptyWithoutBase; }'
rm -rf -- *

# If the intersection exists, the resulting base path is the longest of them
mkdir a
touch x a/b
expectEqual 'toSource { root = ./a; fileset = intersection ./a ./.; }' 'toSource { root = ./a; fileset = ./a; }'
expectEqual 'toSource { root = ./a; fileset = intersection ./. ./a; }' 'toSource { root = ./a; fileset = ./a; }'
rm -rf -- *

# Also finds the intersection with null'd filesetTree's
tree=(
    [a]=0
    [b]=1
    [c]=0
)
checkFileset 'intersection (_create ./. { a = "regular"; b = "regular"; c = null; }) (_create ./. { a = null; b = "regular"; c = "regular"; })'

# Actually computes the intersection between files
tree=(
    [a]=0
    [b]=0
    [c]=1
    [d]=1
    [e]=0
    [f]=0
)
checkFileset 'intersection (unions [ ./a ./b ./c ./d ]) (unions [ ./c ./d ./e ./f ])'

tree=(
    [a/x]=0
    [a/y]=0
    [b/x]=1
    [b/y]=1
    [c/x]=0
    [c/y]=0
)
checkFileset 'intersection ./b ./.'
checkFileset 'intersection ./b (unions [ ./a/x ./a/y ./b/x ./b/y ./c/x ./c/y ])'

# Complicated case
tree=(
    [a/x]=0
    [a/b/i]=1
    [c/d/x]=0
    [c/d/f]=1
    [c/x]=0
    [c/e/i]=1
    [c/e/j]=1
)
checkFileset 'intersection (unions [ ./a/b ./c/d ./c/e ]) (unions [ ./a ./c/d/f ./c/e ])'

## Difference

# Subtracting something from itself results in nothing
tree=(
    [a]=0
)
checkFileset 'difference ./. ./.'

# The tree of the second argument should not be evaluated if not needed
checkFileset 'difference _emptyWithoutBase (_create ./. (abort "This should not be used!"))'
checkFileset 'difference (_create ./. null) (_create ./. (abort "This should not be used!"))'

# Subtracting nothing gives the same thing back
tree=(
    [a]=1
)
checkFileset 'difference ./. _emptyWithoutBase'
checkFileset 'difference ./. (_create ./. null)'

# Subtracting doesn't influence the base path
mkdir a b
touch {a,b}/x
expectEqual 'toSource { root = ./a; fileset = difference ./a ./b; }' 'toSource { root = ./a; fileset = ./a; }'
rm -rf -- *

# Also not the other way around
mkdir a
expectFailure 'toSource { root = ./a; fileset = difference ./. ./a; }' 'lib.fileset.toSource: `fileset` could contain files in '"$work"', which is not under the `root` \('"$work"'/a\). Potential solutions:
[[:blank:]]*- Set `root` to '"$work"' or any directory higher up. This changes the layout of the resulting store path.
[[:blank:]]*- Set `fileset` to a file set that cannot contain files outside the `root` \('"$work"'/a\). This could change the files included in the result.'
rm -rf -- *

# Difference actually works
# We test all combinations of ./., ./a, ./a/x and ./b
tree=(
    [a/x]=0
    [a/y]=0
    [b]=0
    [c]=0
)
checkFileset 'difference ./. ./.'
checkFileset 'difference ./a ./.'
checkFileset 'difference ./a/x ./.'
checkFileset 'difference ./b ./.'
checkFileset 'difference ./a ./a'
checkFileset 'difference ./a/x ./a'
checkFileset 'difference ./a/x ./a/x'
checkFileset 'difference ./b ./b'
tree=(
    [a/x]=0
    [a/y]=0
    [b]=1
    [c]=1
)
checkFileset 'difference ./. ./a'
tree=(
    [a/x]=1
    [a/y]=1
    [b]=0
    [c]=0
)
checkFileset 'difference ./a ./b'
tree=(
    [a/x]=1
    [a/y]=0
    [b]=0
    [c]=0
)
checkFileset 'difference ./a/x ./b'
tree=(
    [a/x]=0
    [a/y]=1
    [b]=0
    [c]=0
)
checkFileset 'difference ./a ./a/x'
tree=(
    [a/x]=0
    [a/y]=0
    [b]=1
    [c]=0
)
checkFileset 'difference ./b ./a'
checkFileset 'difference ./b ./a/x'
tree=(
    [a/x]=0
    [a/y]=1
    [b]=1
    [c]=1
)
checkFileset 'difference ./. ./a/x'
tree=(
    [a/x]=1
    [a/y]=1
    [b]=0
    [c]=1
)
checkFileset 'difference ./. ./b'

## File filter

# The first argument needs to be a function
expectFailure 'fileFilter null (abort "this is not needed")' 'lib.fileset.fileFilter: First argument is of type null, but it should be a function instead.'

# The second argument needs to be an existing path
expectFailure 'fileFilter (file: abort "this is not needed") _emptyWithoutBase' 'lib.fileset.fileFilter: Second argument is a file set, but it should be a path instead.
[[:blank:]]*If you need to filter files in a file set, use `intersection fileset \(fileFilter pred \./\.\)` instead.'
expectFailure 'fileFilter (file: abort "this is not needed") null' 'lib.fileset.fileFilter: Second argument is of type null, but it should be a path instead.'
expectFailure 'fileFilter (file: abort "this is not needed") ./a' 'lib.fileset.fileFilter: Second argument \('"$work"'/a\) is a path that does not exist.'

# The predicate is not called when there's no files
tree=()
checkFileset 'fileFilter (file: abort "this is not needed") ./.'

# The predicate must be able to handle extra attributes
touch a
expectFailure 'toSource { root = ./.; fileset = fileFilter ({ name, type, hasExt }: true) ./.; }' 'called with unexpected argument '\''"lib.fileset.fileFilter: The predicate function passed as the first argument must be able to handle extra attributes for future compatibility. If you'\''re using `\{ name, file, hasExt \}:`, use `\{ name, file, hasExt, ... \}:` instead."'\'
rm -rf -- *

# .name is the name, and it works correctly, even recursively
tree=(
    [a]=1
    [b]=0
    [c/a]=1
    [c/b]=0
    [d/c/a]=1
    [d/c/b]=0
)
checkFileset 'fileFilter (file: file.name == "a") ./.'
tree=(
    [a]=0
    [b]=1
    [c/a]=0
    [c/b]=1
    [d/c/a]=0
    [d/c/b]=1
)
checkFileset 'fileFilter (file: file.name != "a") ./.'

# `.type` is the file type
mkdir d
touch d/a
ln -s d/b d/b
mkfifo d/c
expectEqual \
    'toSource { root = ./.; fileset = fileFilter (file: file.type == "regular") ./.; }' \
    'toSource { root = ./.; fileset = ./d/a; }'
expectEqual \
    'toSource { root = ./.; fileset = fileFilter (file: file.type == "symlink") ./.; }' \
    'toSource { root = ./.; fileset = ./d/b; }'
expectEqual \
    'toSource { root = ./.; fileset = fileFilter (file: file.type == "unknown") ./.; }' \
    'toSource { root = ./.; fileset = ./d/c; }'
expectEqual \
    'toSource { root = ./.; fileset = fileFilter (file: file.type != "regular") ./.; }' \
    'toSource { root = ./.; fileset = union ./d/b ./d/c; }'
expectEqual \
    'toSource { root = ./.; fileset = fileFilter (file: file.type != "symlink") ./.; }' \
    'toSource { root = ./.; fileset = union ./d/a ./d/c; }'
expectEqual \
    'toSource { root = ./.; fileset = fileFilter (file: file.type != "unknown") ./.; }' \
    'toSource { root = ./.; fileset = union ./d/a ./d/b; }'
rm -rf -- *

# Check that .hasExt checks for the file extension
# The empty extension is the same as a file ending with a .
tree=(
    [a]=0
    [a.]=1
    [a.b]=0
    [a.b.]=1
    [a.b.c]=0
)
checkFileset 'fileFilter (file: file.hasExt "") ./.'

# It can check for the last extension
tree=(
    [a]=0
    [.a]=1
    [.a.]=0
    [.b.a]=1
    [.b.a.]=0
)
checkFileset 'fileFilter (file: file.hasExt "a") ./.'

# It can check for any extension
tree=(
    [a.b.c.d]=1
)
checkFileset 'fileFilter (file:
  all file.hasExt [
    "b.c.d"
    "c.d"
    "d"
  ]
) ./.'

# It's lazy
tree=(
    [b]=1
    [c/a]=1
)
# Note that union evaluates the first argument first if necessary, that's why we can use ./c/a here
checkFileset 'union ./c/a (fileFilter (file: assert file.name != "a"; true) ./.)'
# but here we need to use ./c
checkFileset 'union (fileFilter (file: assert file.name != "a"; true) ./.) ./c'

# Make sure single files are filtered correctly
tree=(
    [a]=1
    [b]=0
)
checkFileset 'fileFilter (file: assert file.name == "a"; true) ./a'
tree=(
    [a]=0
    [b]=0
)
checkFileset 'fileFilter (file: assert file.name == "a"; false) ./a'

## Tracing

# The second trace argument is returned
expectEqual 'trace ./. "some value"' 'builtins.trace "(empty)" "some value"'

# The fileset traceVal argument is returned
expectEqual 'traceVal ./.' 'builtins.trace "(empty)" (_create ./. "directory")'

# The tracing happens before the final argument is needed
expectEqual 'trace ./.' 'builtins.trace "(empty)" (x: x)'

# Tracing an empty directory shows it as such
expectTrace './.' '(empty)'

# This also works if there are directories, but all recursively without files
mkdir -p a/b/c
expectTrace './.' '(empty)'
rm -rf -- *

# The empty file set without a base also prints as empty
expectTrace '_emptyWithoutBase' '(empty)'
expectTrace 'unions [ ]' '(empty)'
mkdir foo bar
touch {foo,bar}/x
expectTrace 'intersection ./foo ./bar' '(empty)'
rm -rf -- *

# If a directory is fully included, print it as such
touch a
expectTrace './.' "$work"' (all files in directory)'
rm -rf -- *

# If a directory is not fully included, recurse
mkdir a b
touch a/{x,y} b/{x,y}
expectTrace 'union ./a/x ./b' "$work"'
- a
  - x (regular)
- b (all files in directory)'
rm -rf -- *

# If an included path is a file, print its type
touch a x
ln -s a b
mkfifo c
expectTrace 'unions [ ./a ./b ./c ]' "$work"'
- a (regular)
- b (symlink)
- c (unknown)'
rm -rf -- *

# Do not print directories without any files recursively
mkdir -p a/b/c
touch b x
expectTrace 'unions [ ./a ./b ]' "$work"'
- b (regular)'
rm -rf -- *

# If all children are either fully included or empty directories,
# the parent should be printed as fully included
touch a
mkdir b
expectTrace 'union ./a ./b' "$work"' (all files in directory)'
rm -rf -- *

mkdir -p x/b x/c
touch x/a
touch a
# If all children are either fully excluded or empty directories,
# the parent should be shown (or rather not shown) as fully excluded
expectTrace 'unions [ ./a ./x/b ./x/c ]' "$work"'
- a (regular)'
rm -rf -- *

# Completely filtered out directories also print as empty
touch a
expectTrace '_create ./. {}' '(empty)'
rm -rf -- *

# A general test to make sure the resulting format makes sense
# Such as indentation and ordering
mkdir -p bar/{qux,someDir}
touch bar/{baz,qux,someDir/a} foo
touch bar/qux/x
ln -s x bar/qux/a
mkfifo bar/qux/b
expectTrace 'unions [
  ./bar/baz
  ./bar/qux/a
  ./bar/qux/b
  ./bar/someDir/a
  ./foo
]' "$work"'
- bar
  - baz (regular)
  - qux
    - a (symlink)
    - b (unknown)
  - someDir (all files in directory)
- foo (regular)'
rm -rf -- *

# For recursively included directories,
# `(all files in directory)` should only be used if there's at least one file (otherwise it would be `(empty)`)
# and this should be determined without doing a full search
#
# a is intentionally ordered first here in order to allow triggering the short-circuit behavior
# We then check that b is not read
# In a more realistic scenario, some directories might need to be recursed into,
# but a file would be quickly found to trigger the short-circuit.
touch a
mkdir b
# We don't have lambda's in bash unfortunately,
# so we just define a function instead and then pass its name
# shellcheck disable=SC2317
run() {
    # This shouldn't read b/
    expectTrace './.' "$work"' (all files in directory)'
    # Remove all files immediately after, triggering delete_self events for all of them
    rmdir b
}
# Runs the function while checking that b isn't read
withFileMonitor run b
rm -rf -- *

# Partially included directories trace entries as they are evaluated
touch a b c
expectTrace '_create ./. { a = null; b = "regular"; c = throw "b"; }' "$work"'
- b (regular)'

# Except entries that need to be evaluated to even figure out if it's only partially included:
# Here the directory could be fully excluded or included just from seeing a and b,
# so c needs to be evaluated before anything can be traced
expectTrace '_create ./. { a = null; b = null; c = throw "c"; }' ''
expectTrace '_create ./. { a = "regular"; b = "regular"; c = throw "c"; }' ''
rm -rf -- *

# We can trace large directories (10000 here) without any problems
filesToCreate=({0..9}{0..9}{0..9}{0..9})
expectedTrace=$work$'\n'$(printf -- '- %s (regular)\n' "${filesToCreate[@]}")
# We need an excluded file so it doesn't print as `(all files in directory)`
touch 0 "${filesToCreate[@]}"
expectTrace 'unions (mapAttrsToList (n: _: ./. + "/${n}") (removeAttrs (builtins.readDir ./.) [ "0" ]))' "$expectedTrace"
rm -rf -- *

## lib.fileset.fromSource

# Check error messages

# String-like values are not supported
expectFailure 'fromSource (lib.cleanSource "")' 'lib.fileset.fromSource: The source origin of the argument is a string-like value \(""\), but it should be a path instead.
[[:blank:]]*Sources created from paths in strings cannot be turned into file sets, use `lib.sources` or derivations instead.'

# Wrong type
expectFailure 'fromSource null' 'lib.fileset.fromSource: The source origin of the argument is of type null, but it should be a path instead.'
expectFailure 'fromSource (lib.cleanSource null)' 'lib.fileset.fromSource: The source origin of the argument is of type null, but it should be a path instead.'

# fromSource on non-existent paths gives an error
expectFailure 'fromSource ./a' 'lib.fileset.fromSource: The source origin \('"$work"'/a\) of the argument is a path that does not exist.'

# fromSource on a path works and is the same as coercing that path
mkdir a
touch a/b c
expectEqual 'trace (fromSource ./.) null' 'trace ./. null'
rm -rf -- *

# Check that converting to a file set doesn't read the included files
mkdir a
touch a/b
run() {
    expectEqual "trace (fromSource (lib.cleanSourceWith { src = ./a; })) null" "builtins.trace \"$work/a (all files in directory)\" null"
    rm a/b
}
withFileMonitor run a/b
rm -rf -- *

# Check that converting to a file set doesn't read entries for directories that are filtered out
mkdir -p a/b
touch a/b/c
run() {
    expectEqual "trace (fromSource (lib.cleanSourceWith {
      src = ./a;
      filter = pathString: type: false;
    })) null" "builtins.trace \"(empty)\" null"
    rm a/b/c
    rmdir a/b
}
withFileMonitor run a/b
rm -rf -- *

# The filter is not needed on empty directories
expectEqual 'trace (fromSource (lib.cleanSourceWith {
  src = ./.;
  filter = abort "filter should not be needed";
})) null' 'trace _emptyWithoutBase null'

# Single files also work
touch a b
expectEqual 'trace (fromSource (cleanSourceWith { src = ./a; })) null' 'trace ./a null'
rm -rf -- *

# For a tree assigning each subpath true/false,
# check whether a source filter with those results includes the same files
# as a file set created using fromSource. Usage:
#
# tree=(
#   [a]=1  # ./a is a file and the filter should return true for it
#   [b/]=0 # ./b is a directory and the filter should return false for it
# )
# checkSource
checkSource() {
    createTree

    # Serialise the tree as JSON (there's only minimal savings with jq,
    # and we don't need to handle escapes)
    {
        echo "{"
        first=1
        for p in "${!tree[@]}"; do
            if [[ -z "$first" ]]; then
                echo ","
            else
                first=
            fi
            echo "\"$p\":"
            case "${tree[$p]}" in
                1)
                    echo "true"
                    ;;
                0)
                    echo "false"
                    ;;
                *)
                    die "Unsupported tree value: ${tree[$p]}"
            esac
        done
        echo "}"
    } > "$tmp/tree.json"

    # An expression to create a source value with a filter matching the tree
    sourceExpr='
      let
        tree = importJSON '"$tmp"'/tree.json;
      in
      cleanSourceWith {
        src = ./.;
        filter =
          pathString: type:
          let
            stripped = removePrefix (toString ./. + "/") pathString;
            key = stripped + optionalString (type == "directory") "/";
          in
          tree.${key} or
            (throw "tree key ${key} missing");
      }
    '

    filesetExpr='
      toSource {
        root = ./.;
        fileset = fromSource ('"$sourceExpr"');
      }
    '

    # Turn both into store paths
    sourceStorePath=$(expectStorePath "$sourceExpr")
    filesetStorePath=$(expectStorePath "$filesetExpr")

    # Loop through each path in the tree
    while IFS= read -r -d $'\0' subpath; do
        if [[ ! -e "$sourceStorePath"/"$subpath" ]]; then
            # If it's not in the source store path, it's also not in the file set store path
            if [[ -e "$filesetStorePath"/"$subpath" ]]; then
                die "The store path $sourceStorePath created by $expr doesn't contain $subpath, but the corresponding store path $filesetStorePath created via fromSource does contain $subpath"
            fi
        elif [[ -z "$(find "$sourceStorePath"/"$subpath" -type f)" ]]; then
            # If it's an empty directory in the source store path, it shouldn't be in the file set store path
            if [[ -e "$filesetStorePath"/"$subpath" ]]; then
                die "The store path $sourceStorePath created by $expr contains the path $subpath without any files, but the corresponding store path $filesetStorePath created via fromSource didn't omit it"
            fi
        else
            # If it's non-empty directory or a file, it should be in the file set store path
            if [[ ! -e "$filesetStorePath"/"$subpath" ]]; then
                die "The store path $sourceStorePath created by $expr contains the non-empty path $subpath, but the corresponding store path $filesetStorePath created via fromSource doesn't include it"
            fi
        fi
    done < <(find . -mindepth 1 -print0)

    rm -rf -- *
}

# Check whether the filter is evaluated correctly
tree=(
    [a]=
    [b/]=
    [b/c]=
    [b/d]=
    [e/]=
    [e/e/]=
)
# We fill out the above tree values with all possible combinations of 0 and 1
# Then check whether a filter based on those return values gets turned into the corresponding file set
for i in $(seq 0 $((2 ** ${#tree[@]} - 1 ))); do
    for p in "${!tree[@]}"; do
        tree[$p]=$(( i % 2 ))
        (( i /= 2 )) || true
    done
    checkSource
done

# The filter is called with the same arguments in the same order
mkdir a e
touch a/b a/c d e
expectEqual '
  trace (fromSource (cleanSourceWith {
    src = ./.;
    filter = pathString: type: builtins.trace "${pathString} ${toString type}" true;
  })) null
' '
  builtins.seq (cleanSourceWith {
    src = ./.;
    filter = pathString: type: builtins.trace "${pathString} ${toString type}" true;
  }).outPath
  builtins.trace "'"$work"' (all files in directory)"
  null
'
rm -rf -- *

# Test that if a directory is not included, the filter isn't called on its contents
mkdir a b
touch a/c b/d
expectEqual 'trace (fromSource (cleanSourceWith {
  src = ./.;
  filter = pathString: type:
    if pathString == toString ./a then
      false
    else if pathString == toString ./b then
      true
    else if pathString == toString ./b/d then
      true
    else
      abort "This filter should not be called with path ${pathString}";
})) null' 'trace (_create ./. { b = "directory"; }) null'
rm -rf -- *

# The filter is called lazily:
# If a later say intersection removes a part of the tree, the filter won't run on it
mkdir a d
touch a/{b,c} d/e
expectEqual 'trace (intersection ./a (fromSource (lib.cleanSourceWith {
  src = ./.;
  filter = pathString: type:
    if pathString == toString ./a || pathString == toString ./a/b then
      true
    else if pathString == toString ./a/c then
      false
    else
      abort "filter should not be called on ${pathString}";
}))) null' 'trace ./a/b null'
rm -rf -- *

## lib.fileset.gitTracked/gitTrackedWith

# The first/second argument has to be a path
expectFailure 'gitTracked null' 'lib.fileset.gitTracked: Expected the argument to be a path, but it'\''s a null instead.'
expectFailure 'gitTrackedWith {} null' 'lib.fileset.gitTrackedWith: Expected the second argument to be a path, but it'\''s a null instead.'

# The path must be a directory
touch a
expectFailure 'gitTracked ./a' 'lib.fileset.gitTracked: Expected the argument \('"$work"'/a\) to be a directory, but it'\''s a file instead'
expectFailure 'gitTrackedWith {} ./a' 'lib.fileset.gitTrackedWith: Expected the second argument \('"$work"'/a\) to be a directory, but it'\''s a file instead'
rm -rf -- *

# The path has to contain a .git directory
expectFailure 'gitTracked ./.' 'lib.fileset.gitTracked: Expected the argument \('"$work"'\) to point to a local working tree of a Git repository, but it'\''s not.'
expectFailure 'gitTrackedWith {} ./.' 'lib.fileset.gitTrackedWith: Expected the second argument \('"$work"'\) to point to a local working tree of a Git repository, but it'\''s not.'

# recurseSubmodules has to be a boolean
expectFailure 'gitTrackedWith { recurseSubmodules = null; } ./.' 'lib.fileset.gitTrackedWith: Expected the attribute `recurseSubmodules` of the first argument to be a boolean, but it'\''s a null instead.'

# recurseSubmodules = true is not supported on all Nix versions
if [[ "$(nix-instantiate --eval --expr "$prefixExpression (versionAtLeast builtins.nixVersion _fetchGitSubmodulesMinver)")" == true ]]; then
    fetchGitSupportsSubmodules=1
else
    fetchGitSupportsSubmodules=
    expectFailure 'gitTrackedWith { recurseSubmodules = true; } ./.' 'lib.fileset.gitTrackedWith: Setting the attribute `recurseSubmodules` to `true` is only supported for Nix version 2.4 and after, but Nix version [0-9.]+ is used.'
fi

# Checks that `gitTrackedWith` contains the same files as `git ls-files`
# for the current working directory.
# If --recurse-submodules is passed, the flag is passed through to `git ls-files`
# and as `recurseSubmodules` to `gitTrackedWith`
checkGitTrackedWith() {
    if [[ "${1:-}" == "--recurse-submodules" ]]; then
        gitLsFlags="--recurse-submodules"
        gitTrackedArg="{ recurseSubmodules = true; }"
    else
        gitLsFlags=""
        gitTrackedArg="{ }"
    fi

    # All files listed by `git ls-files`
    expectedFiles=()
    while IFS= read -r -d $'\0' file; do
        # If there are submodules but --recurse-submodules isn't passed,
        # `git ls-files` lists them as empty directories,
        # we need to filter that out since we only want to check/count files
        if [[ -f "$file" ]]; then
            expectedFiles+=("$file")
        fi
    done < <(git ls-files -z $gitLsFlags)

    storePath=$(expectStorePath 'toSource { root = ./.; fileset = gitTrackedWith '"$gitTrackedArg"' ./.; }')

    # Check that each expected file is also in the store path with the same content
    for expectedFile in "${expectedFiles[@]}"; do
        if [[ ! -e "$storePath"/"$expectedFile" ]]; then
            die "Expected file $expectedFile to exist in $storePath, but it doesn't.\nGit status:\n$(git status)\nStore path contents:\n$(find "$storePath")"
        fi
        if ! diff "$expectedFile" "$storePath"/"$expectedFile"; then
            die "Expected file $expectedFile to have the same contents as in $storePath, but it doesn't.\nGit status:\n$(git status)\nStore path contents:\n$(find "$storePath")"
        fi
    done

    # This is a cheap way to verify the inverse: That all files in the store path are also expected
    # We just count the number of files in both and verify they're the same
    actualFileCount=$(find "$storePath" -type f -printf . | wc -c)
    if [[ "${#expectedFiles[@]}" != "$actualFileCount" ]]; then
        die "Expected ${#expectedFiles[@]} files in $storePath, but got $actualFileCount.\nGit status:\n$(git status)\nStore path contents:\n$(find "$storePath")"
    fi
}


# Runs checkGitTrackedWith with and without --recurse-submodules
# Allows testing both variants together
checkGitTracked() {
    checkGitTrackedWith
    if [[ -n "$fetchGitSupportsSubmodules" ]]; then
        checkGitTrackedWith --recurse-submodules
    fi
}

createGitRepo() {
    git init -q "$1"
    # Only repo-local config
    git -C "$1" config user.name "Nixpkgs"
    git -C "$1" config user.email "nixpkgs@nixos.org"
    # Get at least a HEAD commit, needed for older Nix versions
    git -C "$1" commit -q --allow-empty -m "Empty commit"
}

# Check that gitTracked[With] works as expected when evaluated out-of-tree

## First we create a git repositories (and a subrepository) with `default.nix` files referring to their local paths
## Simulating how it would be used in the wild
createGitRepo .
echo '{ fs }: fs.toSource { root = ./.; fileset = fs.gitTracked ./.; }' > default.nix
git add .

## We can evaluate it locally just fine, `fetchGit` is used underneath to filter git-tracked files
expectEqual '(import ./. { fs = lib.fileset; }).outPath' '(builtins.fetchGit ./.).outPath'

## We can also evaluate when importing from fetched store paths
storePath=$(expectStorePath 'builtins.fetchGit ./.')
expectEqual '(import '"$storePath"' { fs = lib.fileset; }).outPath' \""$storePath"\"

## But it fails if the path is imported with a fetcher that doesn't remove .git (like just using "${./.}")
expectFailure 'import "${./.}" { fs = lib.fileset; }' 'lib.fileset.gitTracked: The argument \(.*\) is a store path within a working tree of a Git repository.
[[:blank:]]*This indicates that a source directory was imported into the store using a method such as `import "\$\{./.\}"` or `path:.`.
[[:blank:]]*This function currently does not support such a use case, since it currently relies on `builtins.fetchGit`.
[[:blank:]]*You could make this work by using a fetcher such as `fetchGit` instead of copying the whole repository.
[[:blank:]]*If you can'\''t avoid copying the repo to the store, see https://github.com/NixOS/nix/issues/9292.'

## Even with submodules
if [[ -n "$fetchGitSupportsSubmodules" ]]; then
    ## Both the main repo with the submodule
    echo '{ fs }: fs.toSource { root = ./.; fileset = fs.gitTrackedWith { recurseSubmodules = true; } ./.; }' > default.nix
    createGitRepo sub
    git submodule add ./sub sub >/dev/null
    ## But also the submodule itself
    echo '{ fs }: fs.toSource { root = ./.; fileset = fs.gitTracked ./.; }' > sub/default.nix
    git -C sub add .

    ## We can evaluate it locally just fine, `fetchGit` is used underneath to filter git-tracked files
    expectEqual '(import ./. { fs = lib.fileset; }).outPath' '(builtins.fetchGit { url = ./.; submodules = true; }).outPath'
    expectEqual '(import ./sub { fs = lib.fileset; }).outPath' '(builtins.fetchGit ./sub).outPath'

    ## We can also evaluate when importing from fetched store paths
    storePathWithSub=$(expectStorePath 'builtins.fetchGit { url = ./.; submodules = true; }')
    expectEqual '(import '"$storePathWithSub"' { fs = lib.fileset; }).outPath' \""$storePathWithSub"\"
    storePathSub=$(expectStorePath 'builtins.fetchGit ./sub')
    expectEqual '(import '"$storePathSub"' { fs = lib.fileset; }).outPath' \""$storePathSub"\"

    ## But it fails if the path is imported with a fetcher that doesn't remove .git (like just using "${./.}")
    expectFailure 'import "${./.}" { fs = lib.fileset; }' 'lib.fileset.gitTrackedWith: The second argument \(.*\) is a store path within a working tree of a Git repository.
    [[:blank:]]*This indicates that a source directory was imported into the store using a method such as `import "\$\{./.\}"` or `path:.`.
    [[:blank:]]*This function currently does not support such a use case, since it currently relies on `builtins.fetchGit`.
    [[:blank:]]*You could make this work by using a fetcher such as `fetchGit` instead of copying the whole repository.
    [[:blank:]]*If you can'\''t avoid copying the repo to the store, see https://github.com/NixOS/nix/issues/9292.'
    expectFailure 'import "${./.}/sub" { fs = lib.fileset; }' 'lib.fileset.gitTracked: The argument \(.*/sub\) is a store path within a working tree of a Git repository.
    [[:blank:]]*This indicates that a source directory was imported into the store using a method such as `import "\$\{./.\}"` or `path:.`.
    [[:blank:]]*This function currently does not support such a use case, since it currently relies on `builtins.fetchGit`.
    [[:blank:]]*You could make this work by using a fetcher such as `fetchGit` instead of copying the whole repository.
    [[:blank:]]*If you can'\''t avoid copying the repo to the store, see https://github.com/NixOS/nix/issues/9292.'
fi
rm -rf -- *

# shallow = true is not supported on all Nix versions
# and older versions don't support shallow clones at all
if [[ "$(nix-instantiate --eval --expr "$prefixExpression (versionAtLeast builtins.nixVersion _fetchGitShallowMinver)")" == true ]]; then
    createGitRepo full
    # Extra commit such that there's a commit that won't be in the shallow clone
    git -C full commit --allow-empty -q -m extra
    git clone -q --depth 1 "file://${PWD}/full" shallow
    cd shallow
    checkGitTracked
    cd ..
    rm -rf -- *
fi

# Go through all stages of Git files
# See https://www.git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository

# Empty repository
createGitRepo .
checkGitTracked

# Untracked file
echo a > a
checkGitTracked

# Staged file
git add a
checkGitTracked

# Committed file
git commit -q -m "Added a"
checkGitTracked

# Edited file
echo b > a
checkGitTracked

# Removed file
git rm -f -q a
checkGitTracked

rm -rf -- *

# gitignored file
createGitRepo .
echo a > .gitignore
touch a
git add -A
checkGitTracked

# Add it regardless (needs -f)
git add -f a
checkGitTracked
rm -rf -- *

# Directory
createGitRepo .
mkdir -p d1/d2/d3
touch d1/d2/d3/a
git add d1
checkGitTracked
rm -rf -- *

# Submodules
createGitRepo .
createGitRepo sub

# Untracked submodule
git -C sub commit -q --allow-empty -m "Empty commit"
checkGitTracked

# Tracked submodule
git submodule add ./sub sub >/dev/null
checkGitTracked

# Untracked file
echo a > sub/a
checkGitTracked

# Staged file
git -C sub add a
checkGitTracked

# Committed file
git -C sub commit -q -m "Add a"
checkGitTracked

# Changed file
echo b > sub/b
checkGitTracked

# Removed file
git -C sub rm -f -q a
checkGitTracked

rm -rf -- *

## lib.fileset.maybeMissing

# Argument must be a path
expectFailure 'maybeMissing "someString"' 'lib.fileset.maybeMissing: Argument \("someString"\) is a string-like value, but it should be a path instead.'
expectFailure 'maybeMissing null' 'lib.fileset.maybeMissing: Argument is of type null, but it should be a path instead.'

tree=(
)
checkFileset 'maybeMissing ./a'
checkFileset 'maybeMissing ./b'
checkFileset 'maybeMissing ./b/c'

# Works on single files
tree=(
    [a]=1
    [b/c]=0
    [b/d]=0
)
checkFileset 'maybeMissing ./a'
tree=(
    [a]=0
    [b/c]=1
    [b/d]=0
)
checkFileset 'maybeMissing ./b/c'

# Works on directories
tree=(
    [a]=0
    [b/c]=1
    [b/d]=1
)
checkFileset 'maybeMissing ./b'

# TODO: Once we have combinators and a property testing library, derive property tests from https://en.wikipedia.org/wiki/Algebra_of_sets

echo >&2 tests ok
