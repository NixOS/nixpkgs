#! @shell@
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

path_backup="$PATH"

# That @-vars are substituted separately from bash evaluation makes
# shellcheck think this, and others like it, are useless conditionals.
# shellcheck disable=SC2157
if [[ -n "@coreutils_bin@" && -n "@gnugrep_bin@" ]]; then
    PATH="@coreutils_bin@/bin:@gnugrep_bin@/bin"
fi

source @out@/nix-support/utils.bash

expandResponseParams "$@"
if [[ @wrapperMode@ == prepared ]]; then
    wrapperImport toolchain
    wrapperCompiler=${params[0]:?missing compiler executable}
    params=("${params[@]:1}")
    set -- "${params[@]}"
else
    wrapperClear
    wrapperCompiler=@prog@
    source @out@/nix-support/darwin-sdk-setup.bash
fi


# Parse command line options and set several variables.
# For instance, figure out if linker flags should be passed.
# GCC prints annoying warnings when they are not needed.
dontLink=0
nonFlagArgs=0
cc1=0
# shellcheck disable=SC2193
[[ "$wrapperCompiler" = *++ ]] && isCxx=1 || isCxx=0
cxxInclude=1
cxxLibrary=1
cInclude=1

declare -ag positionalArgs=()
declare -i n=0
nParams=${#params[@]}
while (( "$n" < "$nParams" )); do
    p=${params[n]}
    p2=${params[n+1]:-} # handle `p` being last one
    n+=1

    case "$p" in
        -[cSEM] | -MM) dontLink=1 ;;
        -cc1 | -fc1 ) cc1=1 ;;
        -nostdinc) cInclude=0 cxxInclude=0 ;;
        -nostdinc++) cxxInclude=0 ;;
        -nostdlib) cxxLibrary=0 ;;
        -x*-header) dontLink=1 ;; # both `-x c-header` and `-xc-header` are accepted by clang
        -x)
            case "$p2" in
                *-header) dontLink=1 ;;
            esac
            ;;
        --) # Everything else is positional args!
            # See: https://github.com/llvm/llvm-project/commit/ed1d07282cc9d8e4c25d585e03e5c8a1b6f63a74

            # Any positional arg (i.e. any argument after `--`) will be
            # interpreted as a "non flag" arg:
            if [[ -v "params[$n]" ]]; then nonFlagArgs=1; fi

            positionalArgs=("${params[@]:$n}")
            params=("${params[@]:0:$((n - 1))}")
            break;
            ;;
        -?*) ;;
        *) nonFlagArgs=1 ;; # Includes a solitary dash (`-`) which signifies standard input; it is not a flag
    esac
done

# If we pass a flag like -Wl, then gcc will call the linker unless it
# can figure out that it has to do something else (e.g., because of a
# "-c" flag).  So if no non-flag arguments are given, don't pass any
# linker flags.  This catches cases like "gcc" (should just print
# "gcc: no input files") and "gcc -v" (should print the version).
if [ "$nonFlagArgs" = 0 ]; then
    dontLink=1
fi

# Arocc does not link
if [ "@isArocc@" = 1 ]; then
    dontLink=1
fi

# Optionally filter out paths not refering to the store.
if [[ "${NIX_ENFORCE_PURITY:-}" = 1 && -n "$NIX_STORE" ]]; then
    kept=()
    nParams=${#params[@]}
    declare -i n=0
    while (( "$n" < "$nParams" )); do
        p=${params[n]}
        p2=${params[n+1]:-} # handle `p` being last one
        n+=1

        skipNext=false
        path=""
        case "$p" in
            -[IL]/*) path=${p:2} ;;
            -[IL] | -isystem) path=$p2 skipNext=true ;;
        esac

        if [[ -n $path ]] && badPathWithDarwinSdk "$path"; then
            skip "$path"
            $skipNext && n+=1
            continue
        fi

        kept+=("$p")
    done
    # Old bash empty array hack
    params=(${kept+"${kept[@]}"})
fi

if [[ @wrapperMode@ != prepared ]]; then
    # Put compiler preparation second so libc ldflags retain their ordering.
    source @bintools@/nix-support/add-flags.sh
    source @out@/nix-support/add-flags.sh
fi

# Clear march/mtune=native -- they bring impurity.
if [ "$wrapper_NIX_ENFORCE_NO_NATIVE" = 1 ]; then
    kept=()
    # Old bash empty array hack
    for p in ${params+"${params[@]}"}; do
        if [[ "$p" = -m*=native ]]; then
            >&2 echo "warning: Skipping impure flag $p because NIX_ENFORCE_NO_NATIVE is set"
        else
            kept+=("$p")
        fi
    done
    # Old bash empty array hack
    params=(${kept+"${kept[@]}"})
fi

# Select personality from the primary command in emission order, before
# conditional C++ policy is added. A mode inside that conditional policy or a
# late hook cannot recursively change which policy was selected.
if [[ "@isClang@" == 1 && "@isFlang@" != 1 ]]; then
    primaryDriverArgs=($wrapper_NIX_CFLAGS_COMPILE_BEFORE "${params[@]}" $wrapper_NIX_CFLAGS_COMPILE)
    if [[ $dontLink != 1 ]]; then
        primaryDriverArgs+=($wrapper_NIX_CFLAGS_LINK)
    fi
    # Clang selects its mode before option parsing, even in operands and after --.
    primaryDriverArgs+=("${positionalArgs[@]}")
    for p in "${primaryDriverArgs[@]}"; do
        case "$p" in
            --driver-mode=g++) isCxx=1 ;;
            --driver-mode=*) isCxx=0 ;;
        esac
    done
fi

# -x belongs to native per-input language selection. Clang's C driver still
# needs packaged C++ header defaults without opaque caller C++ arguments.
wrapperCompileFlags "@isClang@"

source @out@/nix-support/add-hardening.sh

# Add the flags for the compiler proper. Flang reads its user-supplied
# flags from the Fortran-specific NIX_FFLAGS_COMPILE channel so that
# C-only flags injected by setup hooks (e.g. -frandom-seed= from
# reproducible-builds.sh, which Flang does not accept) never reach the
# Fortran driver. This mirrors the NIX_GNATFLAGS_COMPILE channel that
# the Ada/GNAT wrapper uses for the same reason.
if [ "@isFlang@" = 1 ]; then
    extraAfter=(${hardeningCFlagsAfter[@]+"${hardeningCFlagsAfter[@]}"} $wrapper_NIX_FFLAGS_COMPILE)
    extraBefore=(${hardeningCFlagsBefore[@]+"${hardeningCFlagsBefore[@]}"} $wrapper_NIX_FFLAGS_COMPILE_BEFORE)
else
    extraAfter=(${hardeningCFlagsAfter[@]+"${hardeningCFlagsAfter[@]}"} $wrapperCFlags)
    extraBefore=(${hardeningCFlagsBefore[@]+"${hardeningCFlagsBefore[@]}"} $wrapper_NIX_CFLAGS_COMPILE_BEFORE)
fi

if [ "$dontLink" != 1 ]; then
    linkType=$(checkLinkType $wrapper_NIX_LDFLAGS_BEFORE "${params[@]}" ${wrapperCFlagsLink:-} $wrapper_NIX_LDFLAGS)

    # Add the flags that should only be passed to the compiler when
    # linking.
    extraAfter+=($(filterRpathFlags "$linkType" $wrapperCFlagsLink))

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding wrapper_NIX_LDFLAGS again).
    for i in $(filterRpathFlags "$linkType" $wrapper_NIX_LDFLAGS_BEFORE); do
        extraBefore+=("-Wl,$i")
    done
    if [[ "$linkType" == dynamic && -n "$wrapper_NIX_DYNAMIC_LINKER" ]]; then
        extraBefore+=("-Wl,-dynamic-linker=$wrapper_NIX_DYNAMIC_LINKER")
    fi
    for i in $(filterRpathFlags "$linkType" $wrapper_NIX_LDFLAGS); do
        if [ "${i:0:3}" = -L/ ]; then
            extraAfter+=("$i")
        else
            extraAfter+=("-Wl,$i")
        fi
    done
fi

if [[ -e @out@/nix-support/add-local-cc-cflags-before.sh ]]; then
    source @out@/nix-support/add-local-cc-cflags-before.sh
fi

# As a very special hack, if the arguments are just `-v', then don't
# add anything.  This is to prevent `gcc -v' (which normally prints
# out the version number and returns exit code 0) from printing out
# `No input files specified' and returning exit code 1.
if [ "$*" = -v ]; then
    extraAfter=()
    extraBefore=()
fi

# clang's -cc1 mode is not compatible with most options
# that we would pass. Rather than trying to pass only
# options that would work, let's just remove all of them.
if [ "$cc1" = 1 ]; then
  extraAfter=()
  extraBefore=()
fi

# Finally, if we got any positional args, append them to `extraAfter`
# now:
if [[ "${#positionalArgs[@]}" -gt 0 ]]; then
    extraAfter+=(-- "${positionalArgs[@]}")
fi

# if a cc-wrapper-hook exists, run it.
if [[ -e @out@/nix-support/cc-wrapper-hook ]]; then
    compiler=$wrapperCompiler
    source @out@/nix-support/cc-wrapper-hook
fi

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    # Old bash workaround, see ld-wrapper for explanation.
    echo "extra flags before to $wrapperCompiler:" >&2
    printf "  %q\n" ${extraBefore+"${extraBefore[@]}"}  >&2
    echo "original flags to $wrapperCompiler:" >&2
    printf "  %q\n" ${params+"${params[@]}"} >&2
    echo "extra flags after to $wrapperCompiler:" >&2
    printf "  %q\n" ${extraAfter+"${extraAfter[@]}"} >&2
fi

export PATH="$path_backup"
wrapperOperation=
if [[ $dontLink != 1 && $cc1 != 1 ]]; then wrapperOperation=link; fi
# Old bash workaround, see above.

if (( "${NIX_CC_USE_RESPONSE_FILE:-@use_response_file_by_default@}" >= 1 )) && canWriteResponseFile \
   ${extraBefore+"${extraBefore[@]}"} \
   ${params+"${params[@]}"} \
   ${extraAfter+"${extraAfter[@]}"}; then
    responseFile=$(@mktemp@ "${TMPDIR:-/tmp}/cc-params.XXXXXX")
    trap '@rm@ -f -- "$responseFile"' EXIT
    writeResponseFile \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"} > "$responseFile"
    (wrapperRun "$wrapperOperation" "$wrapperCompiler" "@$responseFile")
else
    wrapperRun "$wrapperOperation" "$wrapperCompiler" \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"}
fi
