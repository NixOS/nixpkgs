# N.B. It may be a surprise that the derivation-specific variables are exported,
# since this is just sourced by the wrapped binaries---the end consumers. This
# is because one wrapper binary may invoke another (e.g. cc invoking ld). In
# that case, it is cheaper/better to not repeat this step and let the forked
# wrapped binary just inherit the work of the forker's wrapper script.

# Accumulate prefixes for taking in the right input parameters. See setup-hook
# for details.
declare -a role_prefixes=()
if [[ -n "${NIX_CC_WRAPPER_@infixSalt@_TARGET_BUILD:-}" ]]; then
    role_prefixes+=(_BUILD)
fi
if [[ -n "${NIX_CC_WRAPPER_@infixSalt@_TARGET_HOST:-}" ]]; then
    role_prefixes+=('')
fi
if [[ -n "${NIX_CC_WRAPPER_@infixSalt@_TARGET_TARGET:-}" ]]; then
    role_prefixes+=(_TARGET)
fi

# For each role we serve, we accumulate the input parameters into our own
# cc-wrapper-derivation-specific environment variables.
for pre in "${role_prefixes[@]}"; do
    # We need to mangle names for hygiene, but also take parameters/overrides
    # from the environment.
    slurpUnsalted () {
        case "$1" in
            CC_WRAPPER_*)
                local firstPre=NIX_CC_WRAPPER_
                local varname="${1#CC_WRAPPER_}"
                ;;
            LD_WRAPPER_*)
                local firstPre=NIX_LD_WRAPPER_
                local varname="${1#LD_WRAPPER_}"
                ;;
            *)
                local firstPre=NIX_
                local varname="$1"
                ;;
        esac
        local inputVar="${firstPre}${pre}${varname}"
        local outputVar="${firstPre}@infixSalt@_${varname}"
        local delimiter=''
        if [[ -n "${!outputVar:-}" && -n "${!inputVar:-}" ]]; then
            delimiter=' '
        fi
        # Easiest to just do this to deal with either the input or (old) output.
        set +u
        export ${outputVar}+="${delimiter}${!inputVar}"
        set -u
    }

    slurpUnsalted CC_WRAPPER_START_HOOK
    slurpUnsalted CC_WRAPPER_EXEC_HOOK
    slurpUnsalted LD_WRAPPER_START_HOOK
    slurpUnsalted LD_WRAPPER_EXEC_HOOK

    slurpUnsalted CFLAGS_COMPILE
    slurpUnsalted CFLAGS_LINK
    slurpUnsalted CXXSTDLIB_COMPILE
    slurpUnsalted CXXSTDLIB_LINK
    slurpUnsalted GNATFLAGS_COMPILE
    slurpUnsalted IGNORE_LD_THROUGH_GCC
    slurpUnsalted LDFLAGS
    slurpUnsalted LDFLAGS_BEFORE
    slurpUnsalted LDFLAGS_AFTER
    slurpUnsalted LDFLAGS_HARDEN

    slurpUnsalted SET_BUILD_ID
    slurpUnsalted DONT_SET_RPATH
    slurpUnsalted ENFORCE_NO_NATIVE
done
unset -f slurpUnsalted

# `-B@out@/bin' forces cc to use ld-wrapper.sh when calling ld.
export NIX_@infixSalt@_CFLAGS_COMPILE="-B@out@/bin/ $NIX_@infixSalt@_CFLAGS_COMPILE"

# Export and assign separately in order that a failing $(..) will fail
# the script.

if [ -e @out@/nix-support/libc-cflags ]; then
    export NIX_@infixSalt@_CFLAGS_COMPILE
    NIX_@infixSalt@_CFLAGS_COMPILE="$(< @out@/nix-support/libc-cflags) $NIX_@infixSalt@_CFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/cc-cflags ]; then
    export NIX_@infixSalt@_CFLAGS_COMPILE
    NIX_@infixSalt@_CFLAGS_COMPILE="$(< @out@/nix-support/cc-cflags) $NIX_@infixSalt@_CFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/gnat-cflags ]; then
    export NIX_@infixSalt@_GNATFLAGS_COMPILE
    NIX_@infixSalt@_GNATFLAGS_COMPILE="$(< @out@/nix-support/gnat-cflags) $NIX_@infixSalt@_GNATFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/libc-ldflags ]; then
    export NIX_@infixSalt@_LDFLAGS
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/libc-ldflags)"
fi

if [ -e @out@/nix-support/cc-ldflags ]; then
    export NIX_@infixSalt@_LDFLAGS
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/cc-ldflags)"
fi

if [ -e @out@/nix-support/libc-ldflags-before ]; then
    export NIX_@infixSalt@_LDFLAGS_BEFORE
    NIX_@infixSalt@_LDFLAGS_BEFORE="$(< @out@/nix-support/libc-ldflags-before) $NIX_@infixSalt@_LDFLAGS_BEFORE"
fi

# That way forked processes don't againt extend these environment variables
export NIX_CC_WRAPPER_@infixSalt@_FLAGS_SET=1
