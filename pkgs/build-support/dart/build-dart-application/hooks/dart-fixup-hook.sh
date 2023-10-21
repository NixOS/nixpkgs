# shellcheck shell=bash

dartFixupHook() {
    echo "Executing dartFixupHook"

    echo "Providing runtime dependencies"
    if [[ ! -z "$runtimeDependencyLibraryPath" ]]; then
        # Add runtime library dependencies to the LD_LIBRARY_PATH.
        # For some reason, the RUNPATH of the executable is not used to load dynamic libraries in dart:ffi with DynamicLibrary.open().
        #
        # This could alternatively be fixed with patchelf --add-needed, but this would cause all the libraries to be opened immediately,
        # which is not what application authors expect.
        for f in "$out"/bin/*; do
            wrapProgram "$f" --suffix LD_LIBRARY_PATH : "$runtimeDependencyLibraryPath"
        done
    fi

    echo "Finished dartFixupHook"
}

postFixupHooks+=(dartFixupHook)