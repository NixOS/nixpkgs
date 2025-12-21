# shellcheck shell=bash

# checkBinaryArchHook - Verify ELF binaries match the expected architecture
#
# This hook runs during fixupPhase and fails the build if any ELF binary has
# a different e_machine value than expected for the host platform. This helps
# catch cases where prebuilt binaries for the wrong architecture are accidentally
# included in a package.
#
# By default, the hook checks all files in bin/ and lib/ directories (recursively)
# across all outputs.
#
# Configuration variables:
#
#   dontCheckBinaryArch (bool)
#     Set to true to disable the check entirely.
#     Example: dontCheckBinaryArch = true;
#
#   checkBinaryArchExtraPaths (list of strings)
#     Additional paths to check beyond the default bin/ and lib/ directories.
#     Paths are checked recursively.
#     Example: checkBinaryArchExtraPaths = [ "$out/libexec" "$out/share/foo/bin" ];
#
#   checkBinaryArchDebug (bool)
#     Set to true to enable verbose debug output.
#     Example: checkBinaryArchDebug = true;

echo "Sourcing check-binary-arch-hook"

checkBinaryArch() {
    if [[ -n "${dontCheckBinaryArch-}" ]]; then
        return
    fi

    echo "Executing checkBinaryArch"

    local dir
    local pathsToCheck=()

    # Add default paths (bin/ and lib/ in all outputs)
    for output in $(getAllOutputNames); do
        for dir in "${!output}/bin" "${!output}/lib"; do
            if [[ -d "$dir" ]]; then
                pathsToCheck+=("$dir")
            fi
        done
    done

    # Add extra paths from checkBinaryArchExtraPaths
    for dir in ${checkBinaryArchExtraPaths-}; do
        if [[ -d "$dir" ]]; then
            pathsToCheck+=("$dir")
        fi
    done

    if [[ ${#pathsToCheck[@]} -eq 0 ]]; then
        echo "checkBinaryArch: no directories to check, skipping"
        return
    fi

    echo "checkBinaryArch: checking ${pathsToCheck[*]}"

    local debugFlag=""
    if [[ -n "${checkBinaryArchDebug-}" ]]; then
        debugFlag="--debug"
    fi

    python3 @pythonScript@ --cc "$CC" --paths "${pathsToCheck[@]}" $debugFlag
    local ret=$?

    echo "Finished executing checkBinaryArch"
    return $ret
}

postFixupHooks+=(checkBinaryArch)
