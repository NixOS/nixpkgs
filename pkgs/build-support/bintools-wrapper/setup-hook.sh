# Binutils Wrapper hygiene
#
# See comments in cc-wrapper's setup hook. This works exactly the same way.

# Skip setup hook if we're neither a build-time dep, nor, temporarily, doing a
# native compile.
#
# TODO(@Ericson2314): No native exception
[[ -z ${strictDeps-} ]] || (( "$hostOffset" < 0 )) || return 0

bintoolsWrapper_addLDVars () {
    # See ../setup-hooks/role.bash
    local role_post
    getHostRoleEnvHook

    if [[ -d "$1/lib64" && ! -L "$1/lib64" ]]; then
        export NIX_LDFLAGS${role_post}+=" -L$1/lib64"
    fi

    if [[ -d "$1/lib" ]]; then
        # Don't add the /lib directory if it actually doesn't contain any libraries. For instance,
        # Python and Haskell packages often only have directories like $out/lib/ghc-8.4.3/ or
        # $out/lib/python3.6/, so having them in LDFLAGS just makes the linker search unnecessary
        # directories and bloats the size of the environment variable space.
        local -a glob=( $1/lib/lib* )
        if [ "${#glob[*]}" -gt 0 ]; then
            export NIX_LDFLAGS${role_post}+=" -L$1/lib"
        fi
    fi
}

# See ../setup-hooks/role.bash
getTargetRole
getTargetRoleWrapper

addEnvHooks "$targetOffset" bintoolsWrapper_addLDVars

# shellcheck disable=SC2157
if [ -n "@bintools_bin@" ]; then
    addToSearchPath _PATH @bintools_bin@/bin
fi

# shellcheck disable=SC2157
if [ -n "@libc_bin@" ]; then
    addToSearchPath _PATH @libc_bin@/bin
fi

# shellcheck disable=SC2157
if [ -n "@coreutils_bin@" ]; then
    addToSearchPath _PATH @coreutils_bin@/bin
fi

# Export tool environment variables so various build systems use the right ones.

export NIX_BINTOOLS${role_post}=@out@

for cmd in \
    ar as ld nm objcopy objdump readelf ranlib strip strings size windres
do
    if
        PATH=$_PATH type -p "@targetPrefix@${cmd}" > /dev/null
    then
        export "${cmd^^}${role_post}=@targetPrefix@${cmd}";
    fi
done

# If unset, assume the default hardening flags.
: ${NIX_HARDENING_ENABLE="@default_hardening_flags_str@"}
export NIX_HARDENING_ENABLE

# No local scope in sourced file
unset -v role_post cmd upper_case
