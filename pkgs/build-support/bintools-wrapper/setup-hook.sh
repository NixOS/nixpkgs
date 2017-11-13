# Binutils Wrapper hygiene
#
# See comments in cc-wrapper's setup hook. This works exactly the same way.

bintoolsWrapper_addLDVars () {
    case $depOffset in
        -1) local role='BUILD_' ;;
        0)  local role='' ;;
        1)  local role='TARGET_' ;;
        *)  echo "bintools-wrapper: Error: Cannot be used with $depOffset-offset deps, " >2;
            return 1 ;;
    esac

    if [[ -d "$1/lib" ]]; then
        local var="NIX_${role}LDFLAGS"
        export ${var}="-L$1/lib ${!var}"
    fi

    if [[ -d "$1/lib64" && ! -L "$1/lib64" ]]; then
        local var="NIX_${role}LDFLAGS"
        export ${var}="-L$1/lib64 ${!var}"
    fi
}

if [ -n "${crossConfig:-}" ]; then
    export NIX_BINTOOLS_WRAPPER_@infixSalt@_TARGET_BUILD=1
    role_pre='BUILD_'
    role_post='_FOR_BUILD'
else
    export NIX_BINTOOLS_WRAPPER_@infixSalt@_TARGET_HOST=1
    role_pre=""
    role_post=''
fi

envHooks+=(bintoolsWrapper_addLDVars)

# Export tool environment variables so various build systems use the right ones.

export NIX_${role_pre}BINTOOLS=@out@

for cmd in \
    ar as ld nm objcopy objdump readelf ranlib strip strings size windres
do
    if
        PATH=$_PATH type -p "@targetPrefix@${cmd}" > /dev/null
    then
        upper_case="$(echo "$cmd" | tr "[:lower:]" "[:upper:]")"
        export "${role_pre}${upper_case}=@targetPrefix@${cmd}";
        export "${upper_case}${role_post}=@targetPrefix@${cmd}";
    fi
done

# No local scope in sourced file
unset -v role_pre role_post cmd upper_case
