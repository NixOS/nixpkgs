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

    echo "checking for references to $TMPDIR/ in $dir..."

    _processFile() {
        local file="$1"
        if isELF "$file"; then
            if { printf :; patchelf --print-rpath "$file"; } | grep -q -F ":$TMPDIR/"; then
                echo "RPATH of binary $file contains a forbidden reference to $TMPDIR/"
                exit 1
            fi
        elif isScript "$file"; then
            filename=${i##*/}
            dir=${i%/*}
            if [ -e "$dir/.$filename-wrapped" ]; then
                if grep -q -F "$TMPDIR/" "$file"; then
                    echo "wrapper script $file contains a forbidden reference to $TMPDIR/"
                    exit 1
                fi
            fi
        fi
    }

    find "$dir" -type f -not -path '*/.build-id/*' -print0 \
    | parallelMap _processFile

    unset -f _processFile
}
