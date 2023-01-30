#! @shell@

set -eu -o pipefail

# For cmd | while read; do ...; done
shopt -s lastpipe

path_backup="$PATH"
if [ -n "@coreutils_bin@" ]; then
  PATH="@coreutils_bin@/bin"
fi

declare -ri recurThreshold=200
declare -i overflowCount=0

declare -ar origArgs=("$@")

# Throw away what we won't need
declare -a parentArgs=()

while (( $# )); do
    case "$1" in
        -l)
            echo "cctools LD does not support '-l foo'" >&2
            exit 1
            ;;
        -lazy_library | -reexport_library | -upward_library | -weak_library)
            overflowCount+=1
            shift 2
            ;;
        -l* | *.so.* | *.dylib | -lazy-l* | -reexport-l* | -upward-l* | -weak-l*)
            overflowCount+=1
            shift 1
            ;;
        *.a | *.o)
            shift 1
            ;;
        -L | -F)
            # Evidentally ld doesn't like using the child's RPATH, so it still
            # needs these.
            parentArgs+=("$1" "$2")
            shift 2
            ;;
        -L?* | -F?*)
            parentArgs+=("$1")
            shift 1
            ;;
        -o)
            outputName="$2"
            parentArgs+=("$1" "$2")
            shift 2
            ;;
        -install_name | -dylib_install_name | -dynamic-linker | -plugin)
            parentArgs+=("$1" "$2")
            shift 2
            ;;
        -rpath)
            # Only an rpath to the child is needed, which we will add
            shift 2
            ;;
        *)
            if [[ -f "$1" ]]; then
                # Propabably a non-standard object file like Haskell's
                # `.dyn_o`. Skip it like other inputs
                :
            else
                parentArgs+=("$1")
            fi
            shift 1
            ;;
    esac
done



if (( "$overflowCount" <= "$recurThreshold" )); then
    if [ -n "${NIX_DEBUG:-}" ]; then
        echo "ld-wrapper: Only ${overflowCount} inputs counted while ${recurThreshold} is the ceiling, linking normally. " >&2
    fi
    PATH="$path_backup"
    exec @prog@ "${origArgs[@]}"
fi



if [ -n "${NIX_DEBUG:-}" ]; then
    echo "ld-wrapper: ${overflowCount} inputs counted when ${recurThreshold} is the ceiling, inspecting further. " >&2
fi

# Collect the normalized linker input
declare -a norm=()

# Arguments are null-separated
@prog@ --dump-normalized-lib-args "${origArgs[@]}" |
    while IFS= read -r -d '' input; do
        norm+=("$input")
    done

declare -i leafCount=0
declare lastLeaf=''
declare -a childrenInputs=() trailingInputs=()
while (( "${#norm[@]}" )); do
    case "${norm[0]}" in
        -lazy_library | -upward_library)
            # TODO(@Ericson2314): Don't do that, but intersperse children
            # between such args.
            echo "ld-wrapper: Warning: Potentially changing link order" >&2
            trailingInputs+=("${norm[0]}" "${norm[1]}")
            norm=("${norm[@]:2}")
            ;;
        -reexport_library | -weak_library)
            childrenInputs+=("${norm[0]}" "${norm[1]}")
            if [[ "${norm[1]}" != "$lastLeaf" ]]; then
                leafCount+=1
                lastLeaf="${norm[1]}"
            fi
            norm=("${norm[@]:2}")
            ;;
        *.so | *.dylib)
            childrenInputs+=(-reexport_library "${norm[0]}")
            if [[ "${norm[0]}" != "$lastLeaf" ]]; then
                leafCount+=1
                lastLeaf="${norm[0]}"
            fi
            norm=("${norm[@]:1}")
            ;;
        *.o | *.a)
            # Don't delegate object files or static libs
            parentArgs+=("${norm[0]}")
            norm=("${norm[@]:1}")
            ;;
        *)
            if [[ -f "${norm[0]}" ]]; then
                # Propabably a non-standard object file. We'll let it by.
                parentArgs+=("${norm[0]}")
                norm=("${norm[@]:1}")
            else
                echo "ld-wrapper: Internal Error: Invalid normalized argument" >&2
                exit 255
            fi
            ;;
    esac
done



if (( "$leafCount" <= "$recurThreshold" )); then
    if [ -n "${NIX_DEBUG:-}" ]; then
        echo "ld-wrapper: Only ${leafCount} *dynamic* inputs counted while ${recurThreshold} is the ceiling, linking normally. " >&2
    fi
    PATH="$path_backup"
    exec @prog@ "${origArgs[@]}"
fi



if [ -n "${NIX_DEBUG:-}" ]; then
    echo "ld-wrapper: ${leafCount} *dynamic* inputs counted when ${recurThreshold} is the ceiling, delegating to children. " >&2
fi

declare -r outputNameLibless=$( \
    if [[ -z "${outputName:+isUndefined}" ]]; then
        echo unnamed
        return 0;
    fi
    baseName=$(basename ${outputName})
    if [[ "$baseName" = lib* ]]; then
        baseName="${baseName:3}"
    fi
    echo "$baseName")

declare -ra children=(
    "$outputNameLibless-reexport-delegate-0"
    "$outputNameLibless-reexport-delegate-1"
)

mkdir -p "$out/lib"

symbolBloatObject=$outputNameLibless-symbol-hack.o
if [[ ! -f $symbolBloatObject ]]; then
    # `-Q` means use GNU Assembler rather than Clang, avoiding an awkward
    # dependency cycle.
    printf '.private_extern _______child_hack_foo\nchild_hack_foo:\n' |
        PATH="$PATH:@out@/bin" @targetPrefix@as -Q -- -o $symbolBloatObject
fi

# Split inputs between children
declare -a child0Inputs=() child1Inputs=("${childrenInputs[@]}")
let "countFirstChild = $leafCount / 2" || true
lastLeaf=''
while (( "$countFirstChild" )); do
    case "${child1Inputs[0]}" in
        -reexport_library | -weak_library)
            child0Inputs+=("${child1Inputs[0]}" "${child1Inputs[1]}")
            if [[ "${child1Inputs[1]}" != "$lastLeaf" ]]; then
                let countFirstChild-=1 || true
                lastLeaf="${child1Inputs[1]}"
            fi
            child1Inputs=("${child1Inputs[@]:2}")
            ;;
        *.so | *.dylib)
            child0Inputs+=(-reexport_library "${child1Inputs[0]}")
            if [[ "${child1Inputs[0]}" != "$lastLeaf" ]]; then
                let countFirstChild-=1 || true
                lastLeaf="${child1Inputs[1]}"
            fi
            child1Inputs=("${child1Inputs[@]:2}")
            ;;
        *)
            echo "ld-wrapper: Internal Error: Invalid delegated input" >&2
            exit -1
            ;;
    esac
done


# First half of libs
@out@/bin/@targetPrefix@ld \
  -macosx_version_min $MACOSX_DEPLOYMENT_TARGET -arch x86_64 -dylib \
  -o "$out/lib/lib${children[0]}.dylib" \
  -install_name "$out/lib/lib${children[0]}.dylib" \
  "$symbolBloatObject" "${child0Inputs[@]}" "${trailingInputs[@]}"

# Second half of libs
@out@/bin/@targetPrefix@ld \
  -macosx_version_min $MACOSX_DEPLOYMENT_TARGET -arch x86_64 -dylib \
  -o "$out/lib/lib${children[1]}.dylib" \
  -install_name "$out/lib/lib${children[1]}.dylib" \
  "$symbolBloatObject" "${child1Inputs[@]}" "${trailingInputs[@]}"

parentArgs+=("-L$out/lib" -rpath "$out/lib")
if [[ $outputName != *reexport-delegate* ]]; then
	parentArgs+=("-l${children[0]}" "-l${children[1]}")
else
    parentArgs+=("-reexport-l${children[0]}" "-reexport-l${children[1]}")
fi

parentArgs+=("${trailingInputs[@]}")

if [ -n "${NIX_DEBUG:-}" ]; then
    echo "flags using delegated children to @prog@:" >&2
    printf "  %q\n" "${parentArgs[@]}" >&2
fi

PATH="$path_backup"
exec @prog@ "${parentArgs[@]}"
