# shellcheck shell=bash

dartFixupHook() {
    echo "Executing dartFixupHook"

    declare -a wrapProgramArgs

    # Add runtime library dependencies to the LD_LIBRARY_PATH.
    # For some reason, the RUNPATH of the executable is not used to load dynamic libraries in dart:ffi with DynamicLibrary.open().
    #
    # This could alternatively be fixed with patchelf --add-needed, but this would cause all the libraries to be opened immediately,
    # which is not what application authors expect.
    APPLICATION_LD_LIBRARY_PATH=""
    for runtimeDependency in "${runtimeDependencies[@]}"; do
      addToSearchPath APPLICATION_LD_LIBRARY_PATH "${runtimeDependency}/lib"
    done
    if [[ ! -z "$APPLICATION_LD_LIBRARY_PATH" ]]; then
        wrapProgramArgs+=(--suffix LD_LIBRARY_PATH : \"$APPLICATION_LD_LIBRARY_PATH\")
    fi

    if [[ ! -z "$extraWrapProgramArgs" ]]; then
        wrapProgramArgs+=("$extraWrapProgramArgs")
    fi

    if [ ${#wrapProgramArgs[@]} -ne 0 ]; then
        for f in "$out"/bin/*; do
            echo "Wrapping $f..."
            eval "wrapProgram \"$f\" ${wrapProgramArgs[@]}"
        done
    fi

    echo "Finished dartFixupHook"
}

postFixupHooks+=(dartFixupHook)
