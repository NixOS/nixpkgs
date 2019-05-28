# Set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found.
# This is needed to not rely on LD_LIBRARY_PATH which does not work with setuid
# executables. Fixes https://github.com/NixOS/nixpkgs/issues/22760. It must be run
# in postFixup because RUNPATH stripping in fixup would undo it. Note that patchelf
# actually sets RUNPATH not RPATH, which applies only to dependencies of the binary
# it set on (including for dlopen), so the RUNPATH must indeed be set on these
# libraries and would not work if set only on executables.

# When no installed OpenGL drivers are available, we can fall back to
# the vendor-neutral mesa swrast driver. This is about 1MB, but it’s
# very important to have a fallback if we can’t find any drivers
# installed.
addOpenGLRunpath() {
    local forceRpath=

    while [ $# -gt 0 ]; do
        case "$1" in
            --) shift; break;;
            --force-rpath) shift; forceRpath=1;;
            --*)
                echo "addOpenGLRunpath: ERROR: Invalid command line" \
                     "argument: $1" >&2
                return 1;;
            *) break;;
        esac
    done

    for file in "$@"; do
        if ! isELF "$file"; then continue; fi
        local origRpath="$(patchelf --print-rpath "$file")"
        patchelf --set-rpath "@driverLink@/lib:$origRpath:@swrast@/lib" ${forceRpath:+--force-rpath} "$file"
    done
}
