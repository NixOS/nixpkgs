# shellcheck shell=bash
# This setup hook set the HOME environment variable to a writable directory.

export HOME

writableTmpDirAsHome () {
    if [ ! -w "$HOME" ]; then
        HOME="$NIX_BUILD_TOP/.home"
        mkdir -p "$HOME"
        export HOME
    fi
}

postHooks+=(writableTmpDirAsHome)
