# Register dependency flags without selecting linker tools or changing PATH.
# The caller supplies targetOffset and the helpers from role.bash.
bintoolsWrapper_addLDVars () {
    local role_post
    getHostRoleEnvHook

    if [[ -d "$1/lib64" && ! -L "$1/lib64" ]]; then
        export NIX_LDFLAGS"${role_post}"+=" -L$1/lib64"
    fi

    if [[ -d "$1/lib" ]]; then
        # Empty library directories add unnecessary search paths and inflate
        # the environment, notably for Python and Haskell packages.
        local -a glob=( "$1"/lib/lib* )
        if [ "${#glob[*]}" -gt 0 ]; then
            export NIX_LDFLAGS"${role_post}"+=" -L$1/lib"
        fi
    fi
}

addEnvHooks "$targetOffset" bintoolsWrapper_addLDVars
