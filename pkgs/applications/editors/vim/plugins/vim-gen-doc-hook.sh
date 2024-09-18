echo "Sourcing vim-gen-doc-hook"

# the doc folder is copied via the copy_directories entry of the rockspec
# in the folder gitsigns.nvim-scm-1-rocks/gitsigns.nvim/scm-1
vimPluginGenTags() {
    echo "Executing vimPluginGenTags"

    target="$out/@rtpPath@"
    mkdir -p $out/@rtpPath@

    # build help tags
    if [ -d "$target/doc" ]; then
        echo "Building help tags"
        if ! @vimBinary@ -N -u NONE -i NONE -n -E -s -V1 -c "helptags $target/doc" +quit!; then
        echo "Failed to build help tags!"
        exit 1
        fi
    else
        echo "No docs available for $target"
    fi

    if [ -n "$addonInfo" ]; then
        echo "$addonInfo" > $target/addon-info.json
    fi

    echo "Finished executing vimPluginGenTags"
}

preFixupHooks+=(vimPluginGenTags)

