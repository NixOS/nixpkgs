set -u

(( "$hostOffset" < 0 )) || return 0

function accum_haskell_deps () {
    case $depHostOffset in
        -1) local role='_FOR_BUILD' ;;
        0)  local role='' ;;
        1)  local role='_FOR_TARGET' ;;
        *)  return -1 ;; # should already be caught
    esac

    local db="$1/lib/@ghcName@/package.conf.d"
    if [[ -d "$db" ]]; then
        eval "HS_PKG_DBS${role}"'+=("$db")'
    else
        if [ -d "$1/include" ]; then
            eval "HS_FOREIGN_INCDIRS${role}"'+=("$1/include")'
        fi
        if [ -d "$1/lib" ]; then
            eval "HS_FOREIGN_LIBDIRS${role}"'+=("$1/lib")'
        fi
    fi
}


function cabal_deps() {
    local offset="$1"

    case $offset in
        -1) local role='_FOR_BUILD' ;;
        0)  local role='' ;;
        1)  local role='_FOR_TARGET' ;;
        *)  return -1 ;; # should already be caught
    esac

    local db inc lib

    local -na dbs="HS_PKG_DBS${role}"
    local -na incs="HS_FOREIGN_INCDIRS${role}"
    local -na libs="HS_FOREIGN_LIBDIRS${role}"

    for db in "${dbs[@]}"; do
        export CABAL_CONFIG${role}+=" --@pkgdbFlag@=$db"
    done
    for inc in "${incs[@]}"; do
        export CABAL_CONFIG${role}+=" --extra-include-dirs=$inc"
    done
    for lib in "${libs[@]}"; do
        export CABAL_CONFIG${role}+=" --extra-lib-dirs=$lib"
    done
}

preHooks+=("cabal_deps $targetOffset")


case $targetOffset in
    -1) role='_FOR_BUILD' ;;
    0)  role='' ;;
    1)  role='_FOR_TARGET' ;;
    *)  echo "cabal_add_deps: Error: used as improper sort of dependency" >2;
        return 1 ;;
esac

addEnvHooks "$targetOffset" accum_haskell_deps

declare -a HS_PKG_DBS${role}
declare -a HS_FOREIGN_INCDIRS${role}
declare -a HS_FOREIGN_LIBDIRS${role}

declare CABAL_DEPS${role}

unset role
