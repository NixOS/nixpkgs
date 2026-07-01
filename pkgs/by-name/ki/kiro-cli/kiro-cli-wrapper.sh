#!@shell@
# Pre-populate the kiro-cli data dir with assets pinned by this package so
# kiro-cli-chat skips its built-in extraction on every run. The embedded
# bun is a glibc-linked binary that fails on NixOS (issue #516857); we
# redirect to nixpkgs bun via a symlink the runtime accepts because we
# also drop in the bun.sha256 the runtime expects.
set -e

# Skip data-dir setup if we have no usable HOME (e.g. version-check / --help).
# kiro-cli-chat only needs the assets when actually entering the TUI.
if [ -n "${KIRO_DATA_DIR:-}" ]; then
    dataDir="$KIRO_DATA_DIR"
elif [ -n "${XDG_DATA_HOME:-}" ]; then
    dataDir="$XDG_DATA_HOME/kiro-cli"
elif [ -n "${HOME:-}" ]; then
    dataDir="$HOME/.local/share/kiro-cli"
else
    dataDir=
fi

if [ -n "$dataDir" ]; then
    @coreutils@/bin/mkdir -p "$dataDir"
    @coreutils@/bin/ln -sfn "@bun@"           "$dataDir/bun"
    @coreutils@/bin/ln -sfn "@share@/tui.js"  "$dataDir/tui.js"
    @coreutils@/bin/install -m 0644 "@share@/bun.sha256"    "$dataDir/bun.sha256"
    @coreutils@/bin/install -m 0644 "@share@/tui.js.sha256" "$dataDir/tui.js.sha256"
fi

exec "@libexec@" "$@"
