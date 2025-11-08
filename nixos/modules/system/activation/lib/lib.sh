# shellcheck shell=bash

warn() {
    printf "\033[1;35mwarning:\033[0m %s\n" "$*" >&2
}
