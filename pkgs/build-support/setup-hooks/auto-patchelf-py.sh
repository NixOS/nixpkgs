#!/usr/bin/env bash

declare -a autoPatchelfLibs
declare -a extraAutoPatchelfLibs

gatherLibraries() {
    autoPatchelfLibs+=("$1/lib")
}

# shellcheck disable=SC2154
# (targetOffset is referenced but not assigned.)
addEnvHooks "$targetOffset" gatherLibraries

# Can be used to manually add additional directories with shared object files
# to be included for the next autoPatchelf invocation.
addAutoPatchelfSearchPath() {
    local -a findOpts=()

    # XXX: Somewhat similar to the one in the autoPatchelf function, maybe make
    #      it DRY someday...
    while [ $# -gt 0 ]; do
        case "$1" in
            --) shift; break;;
            # Not yet supported.
            # Will behave according to autoPatchelf `--norecurse` flag
            #--no-recurse) shift; findOpts+=("-maxdepth" 1);;
            --*)
                echo "addAutoPatchelfSearchPath: ERROR: Invalid command line" \
                     "argument: $1" >&2
                return 1;;
            *) break;;
        esac
    done

    extraAutoPatchelfLibs+=("$@")
}


autoPatchelf() {
    local norecurse

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

    @pythonInterpreter@ @py_script@                         \
        ${norecurse:+--no-recurse}                           \
        ${autoPatchelfIgnoreMissingDeps:+--ignore-missing}  \
        --paths "$@"                                        \
        --libs "${autoPatchelfLibs[@]}"                     \
               "${extraAutoPatchelfLibs[@]}"                \
        --runtime-dependencies "${runtimeDependencies[@]}"

    # clear the extra set for the next invocation
    extraAutoPatchelfLibs=()
}

# XXX: This should ultimately use fixupOutputHooks but we currently don't have
# a way to enforce the order. If we have $runtimeDependencies set, the setup
# hook of patchelf is going to ruin everything and strip out those additional
# RPATHs.
#
# So what we do here is basically run in postFixup and emulate the same
# behaviour as fixupOutputHooks because the setup hook for patchelf is run in
# fixupOutput and the postFixup hook runs later.

# The following could work (disabling patchelf rpath compression makes sense,
# as we overwrite it ourselves for all the binaries).
# BUT, changing phases breaks tools that rely on having a properly functioning
# install after the fixupPhase.
export dontPatchELF=1
#fixupOutputHooks+=('autoPatchelf')

# shellcheck disable=SC2016
# (Expressions don't expand in single quotes, use double quotes for that.)
postFixupHooks+=('
    if [ -z "${dontAutoPatchelf-}" ]; then
        autoPatchelf -- $(for output in $outputs; do
            [ -e "${!output}" ] || continue
            echo "${!output}"
        done) >&2
    fi
')
