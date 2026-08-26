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

    local tmpdir elf_fifo script_fifo
    tmpdir="$(mktemp -d)"
    elf_fifo="$tmpdir/elf"
    script_fifo="$tmpdir/script"
    mkfifo "$elf_fifo" "$script_fifo"

    # Classifier: identify ELF and script files
    (
        find "$dir" -type f -not -path '*/.build-id/*' -print0 \
        | while IFS= read -r -d $'\0' file; do
            if isELF "$file"; then
                printf '%s\0' "$file" >&3
            elif isScript "$file"; then
                filename=${file##*/}
                dir=${file%/*}
                if [ -e "$dir/.$filename-wrapped" ]; then
                    printf '%s\0' "$file" >&4
                fi
            fi
        done
        exec 3>&- 4>&-
    ) 3> "$elf_fifo" 4> "$script_fifo" &

    # Handler: check RPATHs concurrently
    (
        xargs -0 -r -P "$NIX_BUILD_CORES" -n 1 sh -c '
            if { printf :; patchelf --print-rpath "$1"; } | grep -q -F ":$TMPDIR/"; then
                echo "RPATH of binary $1 contains a forbidden reference to $TMPDIR/"
                exit 1
            fi
        ' _ < "$elf_fifo"
    ) &
    local pid_elf=$!

    # Handler: check wrapper scripts concurrently
    local pid_script
    (
        xargs -0 -r -P "$NIX_BUILD_CORES" -n 1 sh -c '
            if grep -q -F "$TMPDIR/" "$1"; then
                echo "wrapper script $1 contains a forbidden reference to $TMPDIR/"
                exit 1
            fi
        ' _ < "$script_fifo"
    ) &
    local pid_script=$!

    wait "$pid_elf" || { echo "Some binaries contain forbidden references to $TMPDIR/. Check the error above!"; exit 1; }
    wait "$pid_script" || { echo "Some scripts contain forbidden references to $TMPDIR/. Check the error above!"; exit 1; }

    rm -r "$tmpdir"
}
