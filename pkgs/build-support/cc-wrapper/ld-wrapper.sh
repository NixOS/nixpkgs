#! @shell@
set -eu -o pipefail
shopt -s nullglob

path_backup="$PATH"

# phase separation makes this look useless
# shellcheck disable=SC2157
if [ -n "@coreutils_bin@" ]; then
    PATH="@coreutils_bin@/bin"
fi

if [ -z "${NIX_CC_WRAPPER_@infixSalt@_FLAGS_SET:-}" ]; then
    source @out@/nix-support/add-flags.sh
fi

source @out@/nix-support/utils.sh


# Optionally filter out paths not refering to the store.
expandResponseParams "$@"
if [[ "${NIX_ENFORCE_PURITY:-}" = 1 && -n "${NIX_STORE:-}"
        && ( -z "$NIX_@infixSalt@_IGNORE_LD_THROUGH_GCC" || -z "${NIX_@infixSalt@_LDFLAGS_SET:-}" ) ]]; then
    rest=()
    nParams=${#params[@]}
    declare -i n=0
    while (( "$n" < "$nParams" )); do
        p=${params[n]}
        p2=${params[n+1]:-} # handle `p` being last one
        if [ "${p:0:3}" = -L/ ] && badPath "${p:2}"; then
            skip "${p:2}"
        elif [ "$p" = -L ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "$p" = -rpath ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "$p" = -dynamic-linker ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "${p:0:1}" = / ] && badPath "$p"; then
            # We cannot skip this; barf.
            echo "impure path \`$p' used in link" >&2
            exit 1
        elif [ "${p:0:9}" = --sysroot ]; then
            # Our ld is not built with sysroot support (Can we fix that?)
            :
        else
            rest+=("$p")
        fi
        n+=1
    done
    # Old bash empty array hack
    params=(${rest+"${rest[@]}"})
fi

source @out@/nix-support/add-hardening.sh

extraAfter=("${hardeningLDFlags[@]}")
extraBefore=()

if [ -z "${NIX_@infixSalt@_LDFLAGS_SET:-}" ]; then
    extraAfter+=($NIX_@infixSalt@_LDFLAGS)
    extraBefore+=($NIX_@infixSalt@_LDFLAGS_BEFORE)
fi

extraAfter+=($NIX_@infixSalt@_LDFLAGS_AFTER)

declare -a libDirs
declare -A libs
relocatable=

# Find all -L... switches for rpath, and relocatable flags for build id.
if [ "$NIX_@infixSalt@_DONT_SET_RPATH" != 1 ] || [ "$NIX_@infixSalt@_SET_BUILD_ID" = 1 ]; then
    prev=
    # Old bash thinks empty arrays are undefined, ugh.
    for p in \
        ${extraBefore+"${extraBefore[@]}"} \
        ${params+"${params[@]}"} \
        ${extraAfter+"${extraAfter[@]}"}
    do
        case "$prev" in
            -L)
                libDirs+=("$p")
                ;;
            -l)
                libs["lib${p}.so"]=1
                ;;
            -dynamic-linker | -plugin)
                # Ignore this argument, or it will match *.so and be added to rpath.
                ;;
            *)
                case "$p" in
                    -L/*)
                        libDirs+=("${p:2}")
                        ;;
                    -l?*)
                        libs["lib${p:2}.so"]=1
                        ;;
                    "${NIX_STORE:-}"/*.so | "${NIX_STORE:-}"/*.so.*)
                        # This is a direct reference to a shared library.
                        libDirs+=("${p%/*}")
                        libs["${p##*/}"]=1
                        ;;
                    -r | --relocatable | -i)
                        relocatable=1
                esac
                ;;
        esac
        prev="$p"
    done
fi


# Add all used dynamic libraries to the rpath.
if [ "$NIX_@infixSalt@_DONT_SET_RPATH" != 1 ]; then
    # For each directory in the library search path (-L...),
    # see if it contains a dynamic library used by a -l... flag.  If
    # so, add the directory to the rpath.
    # It's important to add the rpath in the order of -L..., so
    # the link time chosen objects will be those of runtime linking.
    declare -A rpaths
    for dir in ${libDirs+"${libDirs[@]}"}; do
        if [[ "$dir" =~ [/.][/.] ]] && dir2=$(readlink -f "$dir"); then
            dir="$dir2"
        fi
        if [ -n "${rpaths[$dir]:-}" ] || [[ "$dir" != "${NIX_STORE:-}"/* ]]; then
            # If the path is not in the store, don't add it to the rpath.
            # This typically happens for libraries in /tmp that are later
            # copied to $out/lib.  If not, we're screwed.
            continue
        fi
        for path in "$dir"/*; do
            file="${path##*/}"
            if [ "${libs[$file]:-}" ]; then
                # This library may have been provided by a previous directory,
                # but if that library file is inside an output of the current
                # derivation, it can be deleted after this compilation and
                # should be found in a later directory, so we add all
                # directories that contain any of the libraries to rpath.
                rpaths["$dir"]=1
                extraAfter+=(-rpath "$dir")
                break
            fi
        done
    done

fi

# This is outside the DONT_SET_RPATH branch because it's more targeted and we
# usually want it (on Darwin) even if DONT_SET_RPATH is set.
if [ -n "${NIX_COREFOUNDATION_RPATH:-}" ]; then
  extraAfter+=(-rpath $NIX_COREFOUNDATION_RPATH)
fi

# Only add --build-id if this is a final link. FIXME: should build gcc
# with --enable-linker-build-id instead?
if [ "$NIX_@infixSalt@_SET_BUILD_ID" = 1 ] && [ ! "$relocatable" ]; then
    extraAfter+=(--build-id)
fi


# Optionally print debug info.
if [ -n "${NIX_DEBUG:-}" ]; then
    # Old bash workaround, see above.
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" ${extraBefore+"${extraBefore[@]}"}  >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" ${params+"${params[@]}"} >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" ${extraAfter+"${extraAfter[@]}"} >&2
fi

PATH="$path_backup"
# Old bash workaround, see above.
exec @prog@ \
    ${extraBefore+"${extraBefore[@]}"} \
    ${params+"${params[@]}"} \
    ${extraAfter+"${extraAfter[@]}"}
