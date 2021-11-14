# shellcheck shell=bash
# Exit with backtrace and error message
#
# Usage: die "Error message"
die() {
    # Let us be a little sloppy with errors, because otherwise the final
    # invocation of `caller` below will cause the script to exit.
    set +e

    # Print our error message
    printf "\nBuilder called die: %b\n" "$*"
    printf "Backtrace:\n"

    # Print a backtrace.
    local frame=0
    while caller $frame; do
        ((frame++));
    done
    printf "\n"

    exit 1
}
