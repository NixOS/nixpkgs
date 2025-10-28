dubSetupHook() {
    echo "Executing dubSetupHook"

    if [ -z "${dubDeps-}" ]; then
        echo "Error: 'dubDeps' must be set when using dubSetupHook."
        exit 1
    fi

    export DUB_HOME="$NIX_BUILD_TOP"/.dub
    echo "Configuring \$DUB_HOME ($DUB_HOME)"
    cp -Tr "$dubDeps"/.dub "$NIX_BUILD_TOP"/.dub
    chmod -R +w "$DUB_HOME"

    echo "Finished dubSetupHook"
}

if [ -z "${dontDubSetup-}" ]; then
    postPatchHooks+=(dubSetupHook)
fi
