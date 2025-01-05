# shellcheck shell=bash
# This setup hook set the HOME environment variable to a temporary directory.

export HOME

tmpdirAsHome () {
    HOME=$(mktemp -d)
    export HOME
}

# shellcheck disable=SC2154
addEnvHooks "$targetOffset" tmpdirAsHome
