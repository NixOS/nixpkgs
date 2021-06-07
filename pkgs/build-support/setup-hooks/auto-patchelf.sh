#!/usr/bin/env bash

declare -a autoPatchelfLibs
declare -Ag autoPatchelfFailedDeps

gatherLibraries() {
    autoPatchelfLibs+=("$1/lib")
}

# wrapper around patchelf to raise proper error messages
# containing the tried file name and command
runPatchelf() {
  patchelf "$@" || (echo "Command failed: patchelf $*" && exit 1)
}

# shellcheck disable=SC2154
# (targetOffset is referenced but not assigned.)
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
    isExeResult="$(LANG=C $READELF -h -l "$1" 2> /dev/null \
        | grep '^ *Type: *EXEC\>\|^ *INTERP\>')"
    # not using grep -q, because it can cause Broken pipe
    [ -n "$isExeResult" ]
}

# We cache dependencies so that we don't need to search through all of them on
# every consecutive call to findDependency.
declare -Ag autoPatchelfCachedDepsAssoc
declare -ag autoPatchelfCachedDeps


addToDepCache() {
    if [[ ${autoPatchelfCachedDepsAssoc[$1]+f} ]]; then return; fi

    # store deps in an assoc. array for efficient lookups
    # otherwise findDependency would have quadratic complexity
    autoPatchelfCachedDepsAssoc["$1"]=""

    # also store deps in normal array to maintain their order
    autoPatchelfCachedDeps+=("$1")
}

declare -gi depCacheInitialised=0
declare -gi doneRecursiveSearch=0
declare -g foundDependency

getDepsFromSo() {
    ldd "$1" 2> /dev/null | sed -n -e 's/[^=]*=> *\(.\+\) \+([^)]*)$/\1/p'
}

populateCacheWithRecursiveDeps() {
    local so found foundso
    for so in "${autoPatchelfCachedDeps[@]}"; do
        for found in $(getDepsFromSo "$so"); do
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

    for dep in "${autoPatchelfCachedDeps[@]}"; do
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

    local interpreter
    interpreter="$(< "$NIX_CC/nix-support/dynamic-linker")"
    if isExecutable "$toPatch"; then
        runPatchelf --set-interpreter "$interpreter" "$toPatch"
        # shellcheck disable=SC2154
        # (runtimeDependencies is referenced but not assigned.)
        if [ -n "$runtimeDependencies" ]; then
            for dep in $runtimeDependencies; do
                rpath="$rpath${rpath:+:}$dep/lib"
            done
        fi
    fi

    echo "searching for dependencies of $toPatch" >&2

    # We're going to find all dependencies based on ldd output, so we need to
    # clear the RPATH first.
    runPatchelf --remove-rpath "$toPatch"

    # If the file is not a dynamic executable, ldd/sed will fail,
    # in which case we return, since there is nothing left to do.
    local missing
    missing="$(
        ldd "$toPatch" 2> /dev/null | \
            sed -n -e 's/^[\t ]*\([^ ]\+\) => not found.*/\1/p'
    )" || return 0

    # This ensures that we get the output of all missing dependencies instead
    # of failing at the first one, because it's more useful when working on a
    # new package where you don't yet know its dependencies.

    for dep in $missing; do
        echo -n "  $dep -> " >&2
        if findDependency "$dep" "$(getSoArch "$toPatch")"; then
            rpath="$rpath${rpath:+:}${foundDependency%/*}"
            echo "found: $foundDependency" >&2
        else
            echo "not found!" >&2
            autoPatchelfFailedDeps["$dep"]="$toPatch"
        fi
    done

    if [ -n "$rpath" ]; then
        echo "setting RPATH to: $rpath" >&2
        runPatchelf --set-rpath "$rpath" "$toPatch"
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

    while IFS= read -r -d '' file; do
    addToDepCache "$file"
    done <  <(find "$@" "${findOpts[@]}" \! -type d \
            \( -name '*.so' -o -name '*.so.*' \) -print0)
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
    # autoPatchelfCachedDeps so that it's chosen first in findDependency.
    addAutoPatchelfSearchPath ${norecurse:+--no-recurse} -- "$@"

    while IFS= read -r -d $'\0' file; do
      isELF "$file" || continue
      segmentHeaders="$(LANG=C $READELF -l "$file")"
      # Skip if the ELF file doesn't have segment headers (eg. object files).
      # not using grep -q, because it can cause Broken pipe
      [ -n "$(echo "$segmentHeaders" | grep '^Program Headers:')" ] || continue
      if isExecutable "$file"; then
          # Skip if the executable is statically linked.
          [ -n "$(echo "$segmentHeaders" | grep "^ *INTERP\\>")" ] || continue
      fi
      # Jump file if patchelf is unable to parse it
      # Some programs contain binary blobs for testing,
      # which are identified as ELF but fail to be parsed by patchelf
      patchelf "$file" || continue
      autoPatchelfFile "$file"
    done < <(find "$@" ${norecurse:+-maxdepth 1} -type f -print0)

    # fail if any dependencies were not found and
    # autoPatchelfIgnoreMissingDeps is not set
    local depsMissing=0
    for failedDep in "${!autoPatchelfFailedDeps[@]}"; do
      echo "autoPatchelfHook could not satisfy dependency $failedDep wanted by ${autoPatchelfFailedDeps[$failedDep]}"
      depsMissing=1
    done
    # shellcheck disable=SC2154
    # (autoPatchelfIgnoreMissingDeps is referenced but not assigned.)
    if [[ $depsMissing == 1 && -z "$autoPatchelfIgnoreMissingDeps" ]]; then
      echo "Add the missing dependencies to the build inputs or set autoPatchelfIgnoreMissingDeps=true"
      exit 1
    fi
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
    if [ -z "${dontAutoPatchelf-}" ]; then
        autoPatchelf -- $(for output in $outputs; do
            [ -e "${!output}" ] || continue
            echo "${!output}"
        done)
    fi
')
