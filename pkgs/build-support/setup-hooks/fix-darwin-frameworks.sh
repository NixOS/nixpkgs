# On Mac OS X, frameworks are linked to the system CoreFoundation but
# dynamic libraries built with nix use a pure version of CF this
# causes segfaults for binaries that depend on it at runtime.  This
# can be solved in two ways.
# 1. Rewrite references to the pure CF using this setup hook, this
# works for the simple case but this can still cause problems if other
# dependencies (eg. python) use the pure CF.
# 2. Create a wrapper for the binary that sets DYLD_FRAMEWORK_PATH to
# /System/Library/Frameworks.  This will make everything load the
# system's CoreFoundation framework while still keeping the
# dependencies pure for other packages.

fixupOutputHooks+=('fixDarwinFrameworksIn $prefix')

fixDarwinFrameworks() {
    local systemPrefix='/System/Library/Frameworks'

    for fn in "$@"; do
        if [ -L "$fn" ]; then continue; fi
        echo "$fn: fixing dylib"

        for framework in $(otool -L "$fn" | awk '/CoreFoundation\.framework/ {print $1}'); do
          install_name_tool -change "$framework" "$systemPrefix/CoreFoundation.framework/Versions/A/CoreFoundation" "$fn" >&2
        done
    done
}

fixDarwinFrameworksIn() {
    local dir="$1"
    fixDarwinFrameworks $(find "$dir" -name "*.dylib")
}
