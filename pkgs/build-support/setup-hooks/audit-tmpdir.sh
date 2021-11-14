# shellcheck shell=bash
# Check whether RPATHs or wrapper scripts contain references to
# $TMPDIR. This is a serious security bug because it allows any user
# to inject files into search paths of other users' processes.
#
# It might be better to have Nix scan build output for any occurrence
# of $TMPDIR (which would also be good for reproducibility), but at
# the moment that would produce too many spurious errors (e.g. debug
# info or assertion messages that refer to $TMPDIR).

fixupOutputHooks+=('if [[ -z "${noAuditTmpdir-}" && -e "$prefix" ]]; then auditTmpdir "$prefix"; fi')

auditTmpdir() {
    local dir="$1"
    [ -e "$dir" ] || return 0

    header "checking for references to $TMPDIR/ in $dir..."

    local i
    while IFS= read -r -d $'\0' i; do
        if [[ "$i" =~ .build-id ]]; then continue; fi

        if isELF "$i"; then
            if { printf :; patchelf --print-rpath "$i"; } | grep -q -F ":$TMPDIR/"; then
                echo "RPATH of binary $i contains a forbidden reference to $TMPDIR/"
                exit 1
            fi
        fi

        if isScript "$i"; then
            if [ -e "$(dirname "$i")/.$(basename "$i")-wrapped" ]; then
                if grep -q -F "$TMPDIR/" "$i"; then
                    echo "wrapper script $i contains a forbidden reference to $TMPDIR/"
                    exit 1
                fi
            fi
        fi

    done < <(find "$dir" -type f -print0)

    stopNest
}
