# Compile and inject a shim that adds RTLD_DEEPBIND to dlopen() calls for
# specified libraries using LD_PRELOAD.

deepbindShimHook() {
    echo "Executing deepbindShimHook"
    # Validate that deepbindShimLibraries is set and non-empty.
    if [[ -z "${deepbindShimLibraries:-}" ]]; then
        echo "Error: 'deepbindShimLibraries' must be set when using deepbindShimHook."
        return 1
    fi

    # Build the C condition expression from the space-separated library list.
    local checks=""
    for lib in $deepbindShimLibraries; do
        if [[ -n "$checks" ]]; then
            checks+=" || "
        fi
        checks+="strstr(filename, \"$lib\")"
    done

    # Generate and compile the shim.
    local shimSrc
    shimSrc=$(mktemp "${TMPDIR:-/tmp}/deepbind-shim-XXXXXX.c")
    sed "s|@DEEPBIND_CHECKS@|$checks|" @shimTemplate@ > "$shimSrc"

    mkdir -p "$out/lib"
    local shimPath="$out/lib/deepbind-shim.so"
    $CC -shared -fPIC -o "$shimPath" "$shimSrc"
    rm -f "$shimSrc"

    # Auto-inject LD_PRELOAD into the first available wrapping mechanism.
    #
    # Detection order (highest to lowest priority):
    #   1. wrapQtAppsHook -> qtWrapperArgs    (registered via fixupOutputHooks)
    #   2. wrapGAppsHook  -> gappsWrapperArgs (registered via fixupOutputHooks)
    #   3. makeWrapper    -> makeWrapperArgs  (fallback; user must call wrapProgram)
    #
    # wrapQtAppsHook and wrapGAppsHook both register functions that run during
    # fixupOutputHooks, which executes after preFixupHooks. So any args we
    # append here will be picked up when wrapping actually happens.
    if declare -p qtWrapperArgs &>/dev/null; then
        qtWrapperArgs+=(--prefix LD_PRELOAD : "$shimPath")
        echo "injected LD_PRELOAD into qtWrapperArgs"
    elif declare -p gappsWrapperArgs &>/dev/null; then
        gappsWrapperArgs+=(--prefix LD_PRELOAD : "$shimPath")
        echo "injected LD_PRELOAD into gappsWrapperArgs"
    elif declare -p makeWrapperArgs &>/dev/null; then
        makeWrapperArgs+=(--prefix LD_PRELOAD : "$shimPath")
        echo "injected LD_PRELOAD into makeWrapperArgs"
    else
        echo "Error: no wrapping mechanism detected to inject the shim."
        echo "  Add wrapQtAppsHook, wrapGAppsHook, or makeWrapper to nativeBuildInputs"
        return 1
    fi
    echo "Finished deepbindShimHook"
}

preFixupHooks+=(deepbindShimHook)
