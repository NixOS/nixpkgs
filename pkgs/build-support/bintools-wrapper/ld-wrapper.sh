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

mainPolicyHandled=0
expandResponseParams "$@"
wrapperLinker=@prog@
if [[ @wrapperMode@ == prepared ]]; then
    wrapperImport toolchain
    wrapperLinker=${params[0]:?missing linker executable}
    params=("${params[@]:1}")
    set -- "${params[@]}"
elif [[ ${NIX_WRAPPER_OPERATION:-} == link ]]; then
    wrapperImport link
    if [[ -n ${wrapper_NIX_LINK_TYPE:-} ]]; then mainPolicyHandled=1; fi
else
    wrapperClear
    source @out@/nix-support/darwin-sdk-setup.bash
    source @out@/nix-support/add-flags.sh
    if [[ "@darwinMinVersion@" ]]; then
        mangleVarSingle @darwinMinVersionVariable@ ${role_suffixes[@]+"${role_suffixes[@]}"}
    fi
fi

# A prepared adapter can delegate to an explicitly selected linker instead of
# the declared bintools. Recognize its native alias rules without probing it.
wrapperLinkerIsLLVM=@bintools_isLLVM@
case "${wrapperLinker##*/}" in
    ld.lld|lld|*-ld.lld) wrapperLinkerIsLLVM=1 ;;
    ld.bfd|ld.gold|*-ld.bfd|*-ld.gold) wrapperLinkerIsLLVM=0 ;;
    ld|*-ld) ;; # Use the declared bintools flavor.
    *) wrapperLinkerIsLLVM=unknown ;;
esac

source @out@/nix-support/add-hardening.sh

# A compiler-rendered loader records earlier policy, not the final output mode.
# Ignore that loader when classifying the actual invocation; later arguments
# may have changed the mode.
renderedLoader=-1
if [[ $mainPolicyHandled == 1 && ${wrapper_NIX_LINK_TYPE:-} == dynamic
        && -n ${wrapper_NIX_DYNAMIC_LINKER:-} ]]; then
    for (( n = 0; n < ${#params[@]}; n++ )); do
        if linkerOptionTakesOperand "${params[n]}"; then (( n+=1 )); continue; fi
        if [[ ${params[n]} == "-dynamic-linker=$wrapper_NIX_DYNAMIC_LINKER" ]]; then
            renderedLoader=$n
            break
        fi
    done
fi
# Classify in the same order as the final invocation. Fresh policy and the
# continuation's trailing policy can themselves select the output mode.
linkTypeBefore=("${hardeningLDFlags[@]}")
linkTypeAfter=($wrapper_NIX_LDFLAGS_AFTER)
if [[ $mainPolicyHandled != 1 ]]; then
    linkTypeBefore+=($wrapper_NIX_LDFLAGS_BEFORE)
    linkTypeAfter=($wrapper_NIX_LDFLAGS "${linkTypeAfter[@]}")
fi
if (( renderedLoader >= 0 )); then
    linkType=$(checkLinkerLinkType "${linkTypeBefore[@]}" "${params[@]:0:renderedLoader}" "${params[@]:renderedLoader+1}" "${linkTypeAfter[@]}")
else
    linkType=$(checkLinkerLinkType "${linkTypeBefore[@]}" "${params[@]}" "${linkTypeAfter[@]}")
fi

# BEFORE policy precedes caller arguments; MAIN policy follows them. Match from
# the corresponding end so equal caller RPATHs retain their original order.
removeRenderedRpaths() {
    local channel value candidate option
    local -a policy values
    local -i n i width match matchWidth step
    for channel in before main; do
        if [[ $channel == before ]]; then
            policy=($wrapper_NIX_LDFLAGS_BEFORE)
        else
            policy=($wrapper_NIX_LDFLAGS)
        fi
        values=()
        for (( n = 0; n < ${#policy[@]}; n++ )); do
            case "${policy[n]}" in
                --) break ;;
                -rpath|--rpath) (( n+=1 )); values+=("${policy[n]:-}") ;;
                -rpath=*|--rpath=*) values+=("${policy[n]#*=}") ;;
                -R|--just-symbols|-just-symbols)
                    option=${policy[n]}; (( n+=1 )); value=${policy[n]:-}
                    if linkerJustSymbolsIsRpath "$value" "$option"; then values+=("$value"); fi ;;
                -R?*|--just-symbols=*|-just-symbols=*)
                    case "${policy[n]}" in -R*) value=${policy[n]:2} ;; *) value=${policy[n]#*=} ;; esac
                    if linkerJustSymbolsIsRpath "$value" "${policy[n]}"; then values+=("$value"); fi ;;
                *) if linkerOptionTakesOperand "${policy[n]}"; then (( n+=1 )); fi ;;
            esac
        done
        if [[ $channel == before ]]; then n=0; step=1
        else n=$((${#values[@]}-1)); step=-1
        fi
        while (( n >= 0 && n < ${#values[@]} )); do
            value=${values[n]}
            match=-1
            for (( i = 0; i < ${#params[@]}; i++ )); do
                case "${params[i]}" in
                    --) break ;;
                    -rpath|--rpath) width=2; candidate=${params[i+1]:-} ;;
                    -rpath=*|--rpath=*) width=1; candidate=${params[i]#*=} ;;
                    -R|--just-symbols|-just-symbols)
                        width=2; candidate=${params[i+1]:-}
                        if ! linkerJustSymbolsIsRpath "$candidate" "${params[i]}"; then (( i+=1 )); continue; fi ;;
                    -R?*|--just-symbols=*|-just-symbols=*)
                        width=1
                        case "${params[i]}" in -R*) candidate=${params[i]:2} ;; *) candidate=${params[i]#*=} ;; esac
                        if ! linkerJustSymbolsIsRpath "$candidate" "${params[i]}"; then continue; fi ;;
                    *)
                        if linkerOptionTakesOperand "${params[i]}"; then (( i+=1 )); fi
                        continue ;;
                esac
                if [[ $candidate == "$value" ]]; then
                    match=$i; matchWidth=$width
                    if [[ $channel == before ]]; then break; fi
                fi
                (( width == 1 )) || (( i+=1 ))
            done
            if (( match >= 0 )); then
                params=("${params[@]:0:match}" "${params[@]:match+matchWidth}")
            fi
            n=$((n+step))
        done
    done
}

# Remove rendered policy that the actual static output cannot use. lld records
# a loader even in a static executable, and a glibc static PIE with an RPATH
# crashes at startup.
if [[ $mainPolicyHandled == 1 && $linkType != dynamic ]]; then
    if (( renderedLoader >= 0 )); then
        params=("${params[@]:0:renderedLoader}" "${params[@]:renderedLoader+1}")
    fi
    if [[ $linkType == static-pie && ${wrapper_NIX_LINK_TYPE:-} != static-pie ]]; then
        removeRenderedRpaths
    fi
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
            # Preserve operand boundaries when checking paths. For example,
            # a SONAME of -L/foo is data, not an impure search directory.
            if linkerOptionTakesOperand "$p" && (( n + 1 < nParams )); then
                if [[ $p2 =~ ^/[^:]*/ ]] && badPath "$p2"; then reject "$p2"; fi
                rest+=("$p2")
                n+=1
            fi
        fi
        n+=1
    done
    # Old bash empty array hack
    params=(${rest+"${rest[@]}"})
fi


extraAfter=()
extraBefore=(${hardeningLDFlags[@]+"${hardeningLDFlags[@]}"})

if [[ $mainPolicyHandled != 1 ]]; then
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
    declare -A rpaths seenLibDirs
    for dir in ${libDirs+"${libDirs[@]}"}; do
        # The same directory is often passed many times, such as from
        # NIX_LDFLAGS; it would give the same result each time.
        if [ -n "${seenLibDirs[$dir]:-}" ]; then
            continue
        fi
        seenLibDirs["$dir"]=1
        # Find where the directory is, following symlinks outside the store,
        # and in it only where needed; see resolveLibDir.  Skip directories
        # that do not exist, in which the linker cannot find libraries either.
        if ! [ -d "$dir" ] || ! resolveLibDir "$dir"; then
            continue
        fi
        dir="$resolvedPath"
        # If the path turns out to be outside the store, we do not add it to rpath.
        # This typically happens for libraries in /tmp that are later
        # copied to $out/lib. If not, we're screwed.
        if [ -n "${rpaths[$dir]:-}" ] || [[ "$dir" != "${NIX_STORE:-}"/* ]]; then
            continue
        fi
        # Every name in libs is that of a shared library, ending in .so or
        # containing .so., so the rest of the directory can be skipped.
        for path in "$dir"/*.so*; do
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

if (( "${NIX_LD_USE_RESPONSE_FILE:-@use_response_file_by_default@}" >= 1 )) && canWriteResponseFile \
   ${extraBefore+"${extraBefore[@]}"} \
   ${params+"${params[@]}"} \
   ${extraAfter+"${extraAfter[@]}"}; then
    responseFile=$(@mktemp@ "${TMPDIR:-/tmp}/ld-params.XXXXXX")
    trap '@rm@ -f -- "$responseFile"' EXIT
    writeResponseFile \
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
