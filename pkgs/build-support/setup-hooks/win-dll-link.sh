set -ue

# If we are not a targetting the host platform of the build, skip this setup
# hook.
(( "$targetOffset" == 0 )) || { set +u; return 0; }

# For every installed *.{exe,dll} in $output/{bin,lib}/ we try to find all
# (potential) transitive dependencies and symlink those DLLs alongside the
# needing EXE/DLL so that they are found on invocation. This is done because
# DLLs are first searched in the directory of the running exe file.
#
# Nota benae:
#
#  - DLLs are still *installed* in lib/ as usual. Only DLL symlinks should go in
#    bin/.
#
#  - The links are relative, so relocating whole /nix/store won't break them.

fixupOutputHooks+=("_linkDLLs bin" "_linkDLLs lib64" "_linkDLLs lib")

_linkDLLs() {
    set -u

    # Ensure exactly 1 argument is passed
    (( "$#" == 1 )) || return 1

    # The directory we're working on
    local curDir="$prefix/$1"

    # Skip if nothing to do
    [[ -d "$curDir" ]] || { set +u; return 0; }
    cd "$curDir"

    local depsDllPath=""
    local flag
    for flag in $NIX_LDFLAGS; do
        case $flag in
            -L*) addToSearchPath dpsDllPath "${flag:2}" ;;
        esac
    done
    unset -v flag

    # Collect lib dirs of current outputs
    local outputsDllPath=""
    local outName
    for outName in $outputs; do
        addToSearchPath outputsDllPath "${!outName}/lib64"
        addToSearchPath outputsDllPath "${!outName}/lib"
    done
    unset -v outname

    # Compose path list where DLLs should be located. Order is
    #  1. Ourself
    #  2. Newly-built outputs
    #  $. Dependencies
    local -r lookupPath="$curDir:$outputsDllPath:$depsDllPath"

    if (( "${NIX_DEBUG:-0}" >= 1 )); then
        echo "DLL lookup path for ${curDir}:"
        local oldIFS="$IFS"
        IFS=:
        for p in $lookupPath; do
            echo "  $p"
        done
        IFS="$oldIFS"
        unset -v oldIFS
    fi

    declare -i linkCount=0

    # Collect all DLLs locations that we depend on. The we use the map as a set
    # to deduplicate found directories.
    local -A dllLocs=()

    local dll
    for dll in \
        $($OBJDUMP -p ./*.{exe,dll} | sed -n 's/.*DLL Name: \(.*\)/\1/p' | sort -u)
    do
        # Locate the DLL - it should be an *executable* file on the lookup path.
        local dllDir dllPath
        dllPath="$(PATH="$lookupPath" type -P "$dll")" || continue
        dllDir="$(dirname "$(readlink -e "$dllPath")")" || continue
        dllLocs["$dllDir"]=1
        unset -v dllDir dllPath
    done
    unset -v dll

    # Each DLL might have its own (transitive) dependencies, so add also all
    # DLLs from its directory to be sure. We *dont't* need to recursively do the
    # previous query because inductively, all inputs have this same fixup output
    # hoook run and symlinks for their deps made.
    local dllPath
    for dllPath in "${!dllLocs[@]}"; do
        local dllPath2
        for dllPath2 in "$dllPath"/*.dll; do
            # Don't override existing file
            [[ -e ./"$(basename "$dllPath2")" ]] || continue

            CYGWIN+=' winsymlinks:nativestrict' ln -sr "$dllPath2" .

            linkCount+=1
        done
        unset -v dllPath2
    done
    unset -v dllPath

    echo "Created $linkCount DLL link(s) in $curDir"

    set +u
}

set +u
