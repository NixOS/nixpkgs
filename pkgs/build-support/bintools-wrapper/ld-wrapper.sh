#! @shell@
# shellcheck shell=bash
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

path_backup="$PATH"

# phase separation makes this look useless
# shellcheck disable=SC2157
if [ -n "@coreutils_bin@" ]; then
    PATH="@coreutils_bin@/bin"
fi

source @out@/nix-support/utils.bash

if [ -z "${NIX_BINTOOLS_WRAPPER_FLAGS_SET_@suffixSalt@:-}" ]; then
    source @out@/nix-support/add-flags.sh
fi


# Optionally filter out paths not refering to the store.
expandResponseParams "$@"

# NIX_LINK_TYPE is set if ld has been called through our cc wrapper. We take
# advantage of this to avoid both recalculating it, and also repeating other
# processing cc wrapper has already done.
if [[ -n "${NIX_LINK_TYPE_@suffixSalt@:-}" ]]; then
    linkType=$NIX_LINK_TYPE_@suffixSalt@
else
    linkType=$(checkLinkType "$@")
fi

if [[ "${NIX_ENFORCE_PURITY:-}" = 1 && -n "${NIX_STORE:-}"
        && ( -z "$NIX_IGNORE_LD_THROUGH_GCC_@suffixSalt@" || -z "${NIX_LINK_TYPE_@suffixSalt@:-}" ) ]]; then
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

extraAfter=()
extraBefore=(${hardeningLDFlags[@]+"${hardeningLDFlags[@]}"})

if [ -z "${NIX_LINK_TYPE_@suffixSalt@:-}" ]; then
    extraAfter+=($(filterRpathFlags "$linkType" $NIX_LDFLAGS_@suffixSalt@))
    extraBefore+=($(filterRpathFlags "$linkType" $NIX_LDFLAGS_BEFORE_@suffixSalt@))

    # By adding dynamic linker to extraBefore we allow the users set their
    # own dynamic linker as NIX_LD_FLAGS will override earlier set flags
    if [[ "$linkType" == dynamic && -n "$NIX_DYNAMIC_LINKER_@suffixSalt@" ]]; then
        extraBefore+=("-dynamic-linker" "$NIX_DYNAMIC_LINKER_@suffixSalt@")
    fi
fi

extraAfter+=($(filterRpathFlags "$linkType" $NIX_LDFLAGS_AFTER_@suffixSalt@))

# These flags *must not* be pulled up to -Wl, flags, so they can't go in
# add-flags.sh. They must always be set, so must not be disabled by
# NIX_LDFLAGS_SET.
if [ -e @out@/nix-support/add-local-ldflags-before.sh ]; then
    source @out@/nix-support/add-local-ldflags-before.sh
fi


# Specify the target emulation if nothing is passed in ("-m" overrides this
# environment variable). Ensures we never blindly fallback on targeting the host
# platform.
: ${LDEMULATION:=@emulation@}

# Three tasks:
#
#   1. Find all -L... switches for rpath
#
#   2. Find relocatable flag for build id.
#
#   3. Choose 32-bit dynamic linker if needed
declare -a libDirs
declare -A libs
declare -i relocatable=0 link32=0

linkerOutput="a.out"

if
    [ "$NIX_DONT_SET_RPATH_@suffixSalt@" != 1 ] \
        || [ "$NIX_SET_BUILD_ID_@suffixSalt@" = 1 ] \
        || [ -e @out@/nix-support/dynamic-linker-m32 ]
then
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
            -m)
                # Presumably only the last `-m` flag has any effect.
                case "$p" in
                    elf_i386) link32=1;;
                    *)        link32=0;;
                esac
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

# Determine linkerOutput
prev=
for p in \
    ${extraBefore+"${extraBefore[@]}"} \
    ${params+"${params[@]}"} \
    ${extraAfter+"${extraAfter[@]}"}
do
    case "$prev" in
        -o)
            # Informational for post-link-hook
            linkerOutput="$p"
            ;;
        *)
            ;;
    esac
    prev="$p"
done

if [[ "$link32" == "1" && "$linkType" == dynamic && -e "@out@/nix-support/dynamic-linker-m32" ]]; then
    # We have an alternate 32-bit linker and we're producing a 32-bit ELF, let's
    # use it.
    extraAfter+=(
        '-dynamic-linker'
        "$(< @out@/nix-support/dynamic-linker-m32)"
    )
fi

# Add all used dynamic libraries to the rpath.
if [[ "$NIX_DONT_SET_RPATH_@suffixSalt@" != 1 && "$linkType" != static-pie ]]; then
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
if [ "$NIX_SET_BUILD_ID_@suffixSalt@" = 1 ] && ! (( "$relocatable" )); then
    extraAfter+=(--build-id)
fi


# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
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
@prog@ \
    ${extraBefore+"${extraBefore[@]}"} \
    ${params+"${params[@]}"} \
    ${extraAfter+"${extraAfter[@]}"}

if [ -e "@out@/nix-support/post-link-hook" ]; then
    source @out@/nix-support/post-link-hook
fi
