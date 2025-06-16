# Parallel execution utilities
# These functions provide a framework for parallel processing of jobs from stdin

# parallelRun - Execute a command in parallel across multiple cores
#
# Reads null-delimited jobs from stdin and distributes them across NIX_BUILD_CORES
# worker processes. Each worker executes the provided command, receiving jobs
# via stdin in null-delimited format.
#
# Usage: some_producer | parallelRun command [args...]
#
# The command receives jobs one at a time via stdin (null-delimited).
#
# Example:
#   find . -name '*.log' -print0 | parallelRun sh -c '
#     while read -r -d "" file; do gzip "$file"; done
#   '
parallelRun() {
    local pids
    local lock
    pids=()
    lock=$(mktemp -u)
    mkfifo "$lock"
    for ((i=0; i<NIX_BUILD_CORES; i++)); do
        {
            exec 3<"$lock"  # fd-3 = read side of lock
            exec 4>"$lock"  # fd-4 = write side of lock (push token back)
            local job

            while :; do
                # Acquire the lock: blocks until a token can be read
                read -r -n1 >/dev/null <&3

                # read one job from stdin
                # This is guarded by the lock above in order to prevent
                # multiple workers from reading from stdin simultaneously.
                if ! IFS= read -r -d '' job; then
                    # If stdin is closed, release lock and exit
                    printf 'x' >&4
                    break
                fi

                # Release the lock: write a token back to the lock FIFO
                printf 'y' >&4

                # Forward job to the worker process' stdin
                printf '%s\0' "$job"

            done \
            | "$@" # launch the worker process
        } &
        pids[$i]=$!
    done
    # launch the workers by writing a token to the lock FIFO
    printf 'a' >"$lock" &
    # Wait for all workers to finish
    for pid in "${pids[@]}"; do
        if ! wait "$pid"; then
            echo "A parallel job failed with exit code $? (check for errors above)" >&2
            echo -e "Failing Command:\n  $@" >&2
            exit 1
        fi
    done
    rm "$lock"
}

# parallelMap - Apply a shell function to each job in parallel
#
# A higher-level wrapper around parallelRun that applies a shell function to each
# null-delimited job from stdin. The shell function receives each job as its first
# argument.
#
# Usage: some_producer | parallelMap shell_function [additional_args...]
#
# The shell function is called as: shell_function job [additional_args...]
# for each job read from stdin.
#
# Example:
#   compress() { gzip "$1" }
#   find . -name '*.log' -print0 | parallelMap compress
parallelMap() {
    _wrapper() {
        while IFS= read -r -d '' job; do
            "$@" "$job"
        done
    }
    parallelRun _wrapper "$@"
    unset -f _wrapper
}
