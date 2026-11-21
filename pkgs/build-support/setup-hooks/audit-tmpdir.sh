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
        # Read file signatures bytewise, including when helpers restore LANG.
        # On Darwin, restoring the default locale can query macOS preferences after fork.
        export LC_ALL=C
        set -o pipefail
        if find "$dir" -type f -not -path '*/.build-id/*' -print0 |
        while IFS= read -r -d $'\0' file; do
            if isELF "$file"; then
                printf '%s\0' "$file" >&3 || exit $?
            elif isScript "$file"; then
                filename=${file##*/}
                dir=${file%/*}
                if [ -e "$dir/.$filename-wrapped" ]; then
                    printf '%s\0' "$file" >&4 || exit $?
                fi
            fi
        done; then
            pipeline_status=0
        else
            pipeline_status=$?
        fi
        exec 3>&- 4>&-
        exit "$pipeline_status"
    ) 3> "$elf_fifo" 4> "$script_fifo" &
    local pid_classifier=$!

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

    local classifier_status=0 elf_status=0 script_status=0 cleanup_status=0
    if wait "$pid_classifier"; then
        classifier_status=0
    else
        classifier_status=$?
        echo "auditTmpdir: classifier/find pipeline failed with status $classifier_status" >&2
    fi
    if wait "$pid_elf"; then
        elf_status=0
    else
        elf_status=$?
        echo "auditTmpdir: ELF handler failed with status $elf_status" >&2
    fi
    if wait "$pid_script"; then
        script_status=0
    else
        script_status=$?
        echo "auditTmpdir: script handler failed with status $script_status" >&2
    fi
    if rm -r "$tmpdir"; then
        cleanup_status=0
    else
        cleanup_status=$?
        echo "auditTmpdir: could not remove temporary directory (status $cleanup_status)" >&2
    fi

    if (( classifier_status != 0 )); then
        return "$classifier_status"
    elif (( elf_status != 0 )); then
        return "$elf_status"
    elif (( script_status != 0 )); then
        return "$script_status"
    else
        return "$cleanup_status"
    fi
}
