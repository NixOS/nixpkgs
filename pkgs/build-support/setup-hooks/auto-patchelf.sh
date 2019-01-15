declare -a autoPatchelfLibs

gatherLibraries() {
    autoPatchelfLibs+=("$1/lib")
}

addEnvHooks "$targetOffset" gatherLibraries

isExecutable() {
    # For dynamically linked ELF files it would be enough to check just for the
    # INTERP section. However, we won't catch statically linked executables as
    # they only have an ELF type of EXEC but no INTERP.
    #
    # So what we do here is just check whether *either* the ELF type is EXEC
    # *or* there is an INTERP section. This also catches position-independent
    # executables, as they typically have an INTERP section but their ELF type
    # is DYN.
    LANG=C readelf -h -l "$1" 2> /dev/null \
        | grep -q '^ *Type: *EXEC\>\|^ *INTERP\>'
}

# We cache dependencies so that we don't need to search through all of them on
# every consecutive call to findDependency.
declare -a cachedDependencies

addToDepCache() {
    local existing
    for existing in "${cachedDependencies[@]}"; do
        if [ "$existing" = "$1" ]; then return; fi
    done
    cachedDependencies+=("$1")
}

declare -gi depCacheInitialised=0
declare -gi doneRecursiveSearch=0
declare -g foundDependency

getDepsFromSo() {
    ldd "$1" 2> /dev/null | sed -n -e 's/[^=]*=> *\(.\+\) \+([^)]*)$/\1/p'
}

populateCacheWithRecursiveDeps() {
    local so found foundso
    for so in "${cachedDependencies[@]}"; do
        for found in $(getDepsFromSo "$so"); do
            local libdir="${found%/*}"
            local base="${found##*/}"
            local soname="${base%.so*}"
            for foundso in "${found%/*}/$soname".so*; do
                addToDepCache "$foundso"
            done
        done
    done
}

getSoArch() {
    objdump -f "$1" | sed -ne 's/^architecture: *\([^,]\+\).*/\1/p'
}

# NOTE: If you want to use this function outside of the autoPatchelf function,
# keep in mind that the dependency cache is only valid inside the subshell
# spawned by the autoPatchelf function, so invoking this directly will possibly
# rebuild the dependency cache. See the autoPatchelf function below for more
# information.
findDependency() {
    local filename="$1"
    local arch="$2"
    local lib dep

    if [ $depCacheInitialised -eq 0 ]; then
        for lib in "${autoPatchelfLibs[@]}"; do
            for so in "$lib/"*.so*; do addToDepCache "$so"; done
        done
        depCacheInitialised=1
    fi

    for dep in "${cachedDependencies[@]}"; do
        if [ "$filename" = "${dep##*/}" ]; then
            if [ "$(getSoArch "$dep")" = "$arch" ]; then
                foundDependency="$dep"
                return 0
            fi
        fi
    done

    # Populate the dependency cache with recursive dependencies *only* if we
    # didn't find the right dependency so far and afterwards run findDependency
    # again, but this time with $doneRecursiveSearch set to 1 so that it won't
    # recurse again (and thus infinitely).
    if [ $doneRecursiveSearch -eq 0 ]; then
        populateCacheWithRecursiveDeps
        doneRecursiveSearch=1
        findDependency "$filename" "$arch" || return 1
        return 0
    fi
    return 1
}

autoPatchelfFile() {
    local dep rpath="" toPatch="$1"

    local interpreter="$(< "$NIX_CC/nix-support/dynamic-linker")"
    if isExecutable "$toPatch"; then
        patchelf --set-interpreter "$interpreter" "$toPatch"
        if [ -n "$runtimeDependencies" ]; then
            for dep in $runtimeDependencies; do
                rpath="$rpath${rpath:+:}$dep/lib"
            done
        fi
    fi

    echo "searching for dependencies of $toPatch" >&2

    # We're going to find all dependencies based on ldd output, so we need to
    # clear the RPATH first.
    patchelf --remove-rpath "$toPatch"

    local missing="$(
        ldd "$toPatch" 2> /dev/null | \
            sed -n -e 's/^[\t ]*\([^ ]\+\) => not found.*/\1/p'
    )"

    # This ensures that we get the output of all missing dependencies instead
    # of failing at the first one, because it's more useful when working on a
    # new package where you don't yet know its dependencies.
    local -i depNotFound=0

    for dep in $missing; do
        echo -n "  $dep -> " >&2
        if findDependency "$dep" "$(getSoArch "$toPatch")"; then
            rpath="$rpath${rpath:+:}${foundDependency%/*}"
            echo "found: $foundDependency" >&2
        else
            echo "not found!" >&2
            depNotFound=1
        fi
    done

    # This makes sure the builder fails if we didn't find a dependency, because
    # the stdenv setup script is run with set -e. The actual error is emitted
    # earlier in the previous loop.
    [ $depNotFound -eq 0 ]

    if [ -n "$rpath" ]; then
        echo "setting RPATH to: $rpath" >&2
        patchelf --set-rpath "$rpath" "$toPatch"
    fi
}

# Can be used to manually add additional directories with shared object files
# to be included for the next autoPatchelf invocation.
addAutoPatchelfSearchPath() {
    local -a findOpts=()

    # XXX: Somewhat similar to the one in the autoPatchelf function, maybe make
    #      it DRY someday...
    while [ $# -gt 0 ]; do
        case "$1" in
            --) shift; break;;
            --no-recurse) shift; findOpts+=("-maxdepth" 1);;
            --*)
                echo "addAutoPatchelfSearchPath: ERROR: Invalid command line" \
                     "argument: $1" >&2
                return 1;;
            *) break;;
        esac
    done

    cachedDependencies+=(
        $(find "$@" "${findOpts[@]}" \! -type d \
               \( -name '*.so' -o -name '*.so.*' \))
    )
}

autoPatchelf() {
    local norecurse=

    while [ $# -gt 0 ]; do
        case "$1" in
            --) shift; break;;
            --no-recurse) shift; norecurse=1;;
            --*)
                echo "autoPatchelf: ERROR: Invalid command line" \
                     "argument: $1" >&2
                return 1;;
            *) break;;
        esac
    done

    if [ $# -eq 0 ]; then
        echo "autoPatchelf: No paths to patch specified." >&2
        return 1
    fi

    echo "automatically fixing dependencies for ELF files" >&2

    # Add all shared objects of the current output path to the start of
    # cachedDependencies so that it's choosen first in findDependency.
    addAutoPatchelfSearchPath ${norecurse:+--no-recurse} -- "$@"

    # Here we actually have a subshell, which also means that
    # $cachedDependencies is final at this point, so whenever we want to run
    # findDependency outside of this, the dependency cache needs to be rebuilt
    # from scratch, so keep this in mind if you want to run findDependency
    # outside of this function.
    while IFS= read -r -d $'\0' file; do
      isELF "$file" || continue
      segmentHeaders="$(LANG=C readelf -l "$file")"
      # Skip if the ELF file doesn't have segment headers (eg. object files).
      echo "$segmentHeaders" | grep -q '^Program Headers:' || continue
      if isExecutable "$file"; then
          # Skip if the executable is statically linked.
          echo "$segmentHeaders" | grep -q "^ *INTERP\\>" || continue
      fi
      autoPatchelfFile "$file"
    done < <(find "$@" ${norecurse:+-maxdepth 1} -type f -print0)
}

# XXX: This should ultimately use fixupOutputHooks but we currently don't have
# a way to enforce the order. If we have $runtimeDependencies set, the setup
# hook of patchelf is going to ruin everything and strip out those additional
# RPATHs.
#
# So what we do here is basically run in postFixup and emulate the same
# behaviour as fixupOutputHooks because the setup hook for patchelf is run in
# fixupOutput and the postFixup hook runs later.
postFixupHooks+=('
    if [ -z "$dontAutoPatchelf" ]; then
        autoPatchelf -- $(for output in $outputs; do
            [ -e "${!output}" ] || continue
            echo "${!output}"
        done)
    fi
')
