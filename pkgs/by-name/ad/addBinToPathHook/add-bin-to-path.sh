# shellcheck shell=bash
# This setup hook add $out/bin to the PATH environment variable.

export PATH

addBinToPath () {
    # shellcheck disable=SC2154
    PATH="$out/bin:$PATH"
    export PATH
}

postHooks+=(addBinToPath)
