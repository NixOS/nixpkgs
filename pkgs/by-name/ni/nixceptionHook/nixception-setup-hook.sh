# Setup hook for the nixception package.
# ======================================
#
# It registers one extra phase: nixceptionStartPhase, registered via
# preConfigurePhases; starts the nixception server and waits until it is ready
# to accept connections on 127.0.0.1:50051.  The server is stopped by hooking
# into stdenv's failureHook and exitHook, which are called by exitHandler (the
# EXIT trap) on failure and success respectively.
#
# The phase is registered before configurePhase (rather than before buildPhase)
# because some build systems (e.g. CMake) probe the compiler during configure.
# When the compiler is wrapped by recc, the nixception server must already be
# listening or those probes will fail with connection-refused errors.
#
# ── Verbosity ────────────────────────────────────────────────────────────────
#
# By default the hook runs in quiet mode: the nixception server's output is
# sent to a log file and lifecycle messages are suppressed.  Set
# NIXCEPTION_VERBOSE=1 in the build environment to get all the debug messages
#
# On build *failure* the server log is always dumped to stderr regardless of
# the verbosity setting, so you can still debug without re-running.
#
# ── Shutdown ─────────────────────────────────────────────────────────────────
#
# stdenv's exitHandler (set as the EXIT trap before any setup hook runs) calls:
#   runHook failureHook   – on non-zero exit
#   runHook exitHook      – on clean exit
#
# We append our stop command to both hooks so the server is always torn down,
# whether the build succeeds or fails.
#
# ── Extra sandbox tools ──────────────────────────────────────────────────────
#
# To make extra tools available inside the reapi-action sandbox, export
# NIXCEPTION_EXTRA_SANDBOX_PATHS (colon-separated /nix/store/… paths) in the
# build environment *before* this phase runs.

# shellcheck shell=bash

# Helper: print a message only in verbose mode.
_nixception_log() {
    if [ "${NIXCEPTION_VERBOSE:-0}" = "1" ]; then
        echo "nixception-hook: $*" >&2
    fi
}

_nixception_pid=
_nixception_logfile=

_nixceptionStop() {
    _nixception_log "stopping server (pid $_nixception_pid)..."
    kill "$_nixception_pid" 2>/dev/null || true
    wait "$_nixception_pid" 2>/dev/null || true

    # Print timing summary
    if [ -s "$NIXCEPTION_STATS_FILE" ]; then
        echo '' >&2
        echo 'nixception-hook: ── timing statistics ──' >&2
        cat "$NIXCEPTION_STATS_FILE" >&2
    else
        _nixception_log "no timing statistics available"
    fi
    rm -f "$NIXCEPTION_STATS_FILE"
}

_nixceptionFailStop() {
    _nixceptionStop

    # In quiet mode, dump the server log on failure so the user can debug
    # without re-running in verbose mode.
    if [ "${NIXCEPTION_VERBOSE:-0}" != "1" ] && [ -s "$_nixception_logfile" ]; then
        echo '' >&2
        echo 'nixception-hook: ── server log (last 200 lines) ──' >&2
        tail -n 200 "$_nixception_logfile" >&2
        echo 'nixception-hook: ── end of server log ──' >&2
        echo '(set NIXCEPTION_VERBOSE=1 for full real-time output)' >&2
    fi
    rm -f "$_nixception_logfile"
}

# Clean exit: just stop the server (and remove the log file).
_nixceptionCleanStop() {
    _nixceptionStop
    rm -f "$_nixception_logfile"
}

nixceptionStartPhase() {
    # ── Sanity-check: recursive-nix socket ───────────────────────────────────
    # The Nix daemon socket is exposed at /build/.nix-socket when the sandbox
    # is started with the recursive-nix system feature.  Fail fast so the
    # error is obvious rather than a cryptic connection-refused from nixception.
    test -S /build/.nix-socket || {
        echo "nixception-hook: FAIL: recursive-nix daemon socket not found" \
            '– is requiredSystemFeatures = ["recursive-nix"] set?' >&2
        exit 1
    }

    local _verbose="${NIXCEPTION_VERBOSE:-0}"

    # Stats file
    export NIXCEPTION_STATS_FILE
    NIXCEPTION_STATS_FILE="$(mktemp -p /build nixception-stats.XXXXXX)"

    # Server log file (used in quiet mode)
    _nixception_logfile="$(mktemp -p /build nixception-server.log.XXXXXX)"

    # Verbosiy
    # In verbose mode the default RUST_LOG level is "info" and server output is
    # timestamped and forwarded to stderr.  In quiet mode the level drops to
    # "warn" and output goes to a log file that is only shown on failure.
    # If the caller already set RUST_LOG we never override it.
    local _rust_log
    if [ -n "${RUST_LOG:-}" ]; then
        _rust_log="$RUST_LOG"
    elif [ "$_verbose" = "1" ]; then
        _rust_log="info"
    else
        _rust_log="warn"
    fi

    # Start the server
    _nixception_log "starting nixception server..."
    if [ "$_verbose" = "1" ]; then
        RUST_LOG="$_rust_log" \
            RUST_BACKTRACE=1 \
            @nixception@/bin/nixception \
            > >(@moreutils@/bin/ts -s '[nixception] %H:%M:%.S' >&2) 2>&1 &
    else
        RUST_LOG="$_rust_log" \
            RUST_BACKTRACE=1 \
            @nixception@/bin/nixception \
            > "$_nixception_logfile" 2>&1 &
    fi
    _nixception_pid=$!

    # Register exit hooks
    exitHook+=$'\n_nixceptionCleanStop\n'
    failureHook+=$'\n_nixceptionFailStop\n'

    # Wait for the server to be ready
    @wait4x@/bin/wait4x tcp 127.0.0.1:50051 --timeout 30s --quiet
    _nixception_log "server is ready (pid $_nixception_pid)"
}

preConfigurePhases="${preConfigurePhases:-} nixceptionStartPhase"
