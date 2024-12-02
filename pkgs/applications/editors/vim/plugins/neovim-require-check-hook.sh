#shellcheck shell=bash
# Setup hook for checking whether Python imports succeed
echo "Sourcing neovim-require-check-hook.sh"

neovimRequireCheckHook () {
    echo "Executing neovimRequireCheckHook"

    if [ -n "$nvimRequireCheck" ]; then
        echo "Check whether the following module can be imported: $nvimRequireCheck"

		# editorconfig-checker-disable
        export HOME="$TMPDIR"

        local deps="${dependencies[*]}"
        @nvimBinary@ -es --headless -n -u NONE -i NONE --clean -V1 \
            --cmd "set rtp+=$out,${deps// /,}" \
            --cmd "lua require('$nvimRequireCheck')"
    fi
}

echo "Using neovimRequireCheckHook"
appendToVar preDistPhases neovimRequireCheckHook


