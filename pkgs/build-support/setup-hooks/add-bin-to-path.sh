# shellcheck shell=bash
# This setup hook add $out/bin to the PATH environment variable.

export PATH

addBinToPath () {
    # shellcheck disable=SC2154
    if [ -d "$out/bin" ]; then
        PATH="$out/bin:$PATH"
        export PATH
    fi
}

# shellcheck disable=SC2154
addEnvHooks "$targetOffset" addBinToPath
