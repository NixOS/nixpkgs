# Register dependency flags without selecting compiler tools or changing PATH.
# The caller supplies targetOffset and the helpers from role.bash. Callback
# names distinguish the captured macro-prefix-map policy; registrations retain
# their order and multiplicity even when they share a callback.
ccWrapper_addCVars_@useMacroPrefixMap@ () {
    local role_post
    getHostRoleEnvHook

    local found=

    if [ -d "$1/include" ]; then
        export NIX_CFLAGS_COMPILE"${role_post}"+=" -isystem $1/include"
        found=1
    fi

    if [ -d "$1/Library/Frameworks" ]; then
        export NIX_CFLAGS_COMPILE"${role_post}"+=" -iframework $1/Library/Frameworks"
        found=1
    fi

    # shellcheck disable=SC2157
    if [[ -n "@useMacroPrefixMap@" && -n ${NIX_STORE:-} && -n $found ]]; then
        local scrubbed="$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${1#"$NIX_STORE"/*-}"
        export NIX_CFLAGS_COMPILE"${role_post}"+=" -fmacro-prefix-map=$1=$scrubbed"
    fi
}

addEnvHooks "$targetOffset" ccWrapper_addCVars_@useMacroPrefixMap@
