# Setup hook for checking whether a vim command exists
echo "Sourcing vim-command-check-hook.sh"

vimCommandCheckHook () {
    echo "Executing vimCommandCheckHook"

    if [ -n "$vimCommandCheck" ]; then
        echo "Check whether the following modules can be imported: $vimCommandCheck"

		# editorconfig-checker-disable
        export HOME="$TMPDIR"
        @vimBinary@ -es -n -u NONE -i NONE --clean -V1 --cmd "set rtp+=$out" \
			--cmd "runtime! plugin/*.vim"  <<-EOF
			if exists(":$vimCommandCheck") == 2
				cquit 0
			else
				cquit 1
			fi
			EOF
    fi
}

echo "Using vimCommandCheckHook"
preDistPhases+=" vimCommandCheckHook"

