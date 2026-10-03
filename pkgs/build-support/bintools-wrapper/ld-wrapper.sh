#! @shell@
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

expandResponseParams "$@"
wrapperLinker=@prog@
if [[ @wrapperMode@ == prepared ]]; then
    wrapperImport toolchain
    wrapperLinker=${params[0]:?missing linker executable}
    params=("${params[@]:1}")
    set -- "${params[@]}"
elif [[ ${NIX_WRAPPER_OPERATION:-} == link ]]; then
    wrapperImport link
else
    wrapperClear
    source @out@/nix-support/darwin-sdk-setup.bash
    source @out@/nix-support/add-flags.sh
    if [[ "@darwinMinVersion@" ]]; then
        mangleVarSingle @darwinMinVersionVariable@ ${role_suffixes[@]+"${role_suffixes[@]}"}
    fi
fi

# A link continuation records the mode selected by the compiler. We take
# advantage of this to avoid both recalculating it, and also repeating other
# processing cc wrapper has already done.
if [[ -n "${wrapper_NIX_LINK_TYPE:-}" ]]; then
    linkType=$wrapper_NIX_LINK_TYPE
else
    linkType=$(checkLinkType "${params[@]}")
fi

if [[ "${NIX_ENFORCE_PURITY:-}" = 1 && -n "${NIX_STORE:-}"
        && ( -z "$wrapper_NIX_IGNORE_LD_THROUGH_GCC" || -z "${wrapper_NIX_LINK_TYPE:-}" ) ]]; then
    rest=()
    nParams=${#params[@]}
    declare -i n=0

    while (( "$n" < "$nParams" )); do
        p=${params[n]}
        p2=${params[n+1]:-} # handle `p` being last one
        if [ "${p:0:3}" = -L/ ] && badPathWithDarwinSdk "${p:2}"; then
            skip "${p:2}"
        elif [ "$p" = -L ] && badPathWithDarwinSdk "$p2"; then
            n+=1; skip "$p2"
        elif [ "$p" = -rpath ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "$p" = -dynamic-linker ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "$p" = -syslibroot ] && [ $p2 == // ]; then
            # When gcc is built on darwin --with-build-sysroot=/
            # produces '-syslibroot //' linker flag. It's a no-op,
            # which does not introduce impurities.
            n+=1; skip "$p2"
        elif [ "${p:0:10}" = /LIBPATH:/ ] && badPath "${p:9}"; then
            reject "${p:9}"
        # We need to not match LINK.EXE-style flags like
        # /NOLOGO or /LIBPATH:/nix/store/foo
        elif [[ $p =~ ^/[^:]*/ ]] && badPath "$p"; then
            reject "$p"
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

if [ -z "${wrapper_NIX_LINK_TYPE:-}" ]; then
    extraAfter+=($(filterRpathFlags "$linkType" $wrapper_NIX_LDFLAGS))
    extraBefore+=($(filterRpathFlags "$linkType" $wrapper_NIX_LDFLAGS_BEFORE))

    # By adding dynamic linker to extraBefore we allow the users set their
    # own dynamic linker as NIX_LD_FLAGS will override earlier set flags
    if [[ "$linkType" == dynamic && -n "$wrapper_NIX_DYNAMIC_LINKER" ]]; then
        extraBefore+=("-dynamic-linker" "$wrapper_NIX_DYNAMIC_LINKER")
    fi
fi

extraAfter+=($(filterRpathFlags "$linkType" $wrapper_NIX_LDFLAGS_AFTER))

# These flags *must not* be pulled up to -Wl, flags, so they can't go in
# add-flags.sh. They must always be set, so must not be disabled by
# the compiler having already emitted the main linker flags.
if [ -e @out@/nix-support/add-local-ldflags-before.sh ]; then
    source @out@/nix-support/add-local-ldflags-before.sh
fi


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
    [ "$wrapper_NIX_DONT_SET_RPATH" != 1 ] \
        || [ "$wrapper_NIX_SET_BUILD_ID" = 1 ] \
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
if [[ "$wrapper_NIX_DONT_SET_RPATH" != 1 && "$linkType" != static-pie ]]; then
    # For each directory in the library search path (-L...),
    # see if it contains a dynamic library used by a -l... flag.  If
    # so, add the directory to the rpath.
    # It's important to add the rpath in the order of -L..., so
    # the link time chosen objects will be those of runtime linking.
    declare -A rpaths
    for dir in ${libDirs+"${libDirs[@]}"}; do
        # If the path is in the store, do not resolve any symlinks and add it to the rpath.
        # Resolving symlinks in the store breaks bootstrapping, see issue #454199.
        # If it is outside the store, resolve symlinks step by step until it falls
        # into the store or it becomes not a symlink.
        # Always canonicalize the path before checking it is in the store or not.
        if dir2=$(realpath -s "$dir"); then
            dir="$dir2"
        else
            continue
        fi
        while [ -z "${rpaths[$dir]:-}" ] && [[ "$dir" != "${NIX_STORE:-}"/* ]] && [ -L "$dir" ]; do
            if dir2=$(readlink "$dir"); then
                dir="dir2"
            else
                break
            fi
            if dir2=$(realpath -s "$dir"); then
                dir="dir2"
            else
                break
            fi
        done
        # If the path turns out to be outside the store, we do not add it to rpath.
        # This typically happens for libraries in /tmp that are later
        # copied to $out/lib. If not, we're screwed.
        if [ -n "${rpaths[$dir]:-}" ] || [[ "$dir" != "${NIX_STORE:-}"/* ]]; then
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

# Only add --build-id if this is a final link. FIXME: should build gcc
# with --enable-linker-build-id instead?
#
# Note: `lld` interprets `--build-id` to mean `--build-id=fast`; GNU ld defaults
# to SHA1.
if [ "$wrapper_NIX_SET_BUILD_ID" = 1 ] && ! (( "$relocatable" )); then
    extraAfter+=(--build-id="${NIX_BUILD_ID_STYLE:-sha1}")
fi

# if a ld-wrapper-hook exists, run it.
if [[ -e @out@/nix-support/ld-wrapper-hook ]]; then
    linker=$wrapperLinker
    source @out@/nix-support/ld-wrapper-hook
fi

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    # Old bash workaround, see above.
    echo "extra flags before to $wrapperLinker:" >&2
    printf "  %q\n" ${extraBefore+"${extraBefore[@]}"}  >&2
    echo "original flags to $wrapperLinker:" >&2
    printf "  %q\n" ${params+"${params[@]}"} >&2
    echo "extra flags after to $wrapperLinker:" >&2
    printf "  %q\n" ${extraAfter+"${extraAfter[@]}"} >&2
fi

export PATH="$path_backup"
# Old bash workaround, see above.

if (( "${NIX_LD_USE_RESPONSE_FILE:-@use_response_file_by_default@}" >= 1 )); then
    responseFile=$(@mktemp@ "${TMPDIR:-/tmp}/ld-params.XXXXXX")
    trap '@rm@ -f -- "$responseFile"' EXIT
    printf "%q\n" \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"} > "$responseFile"
    (wrapperRun "" "$wrapperLinker" "@$responseFile")
else
    (wrapperRun "" "$wrapperLinker" \
        ${extraBefore+"${extraBefore[@]}"} \
        ${params+"${params[@]}"} \
        ${extraAfter+"${extraAfter[@]}"})
fi

if [ -e "@out@/nix-support/post-link-hook" ]; then
    source @out@/nix-support/post-link-hook
fi
