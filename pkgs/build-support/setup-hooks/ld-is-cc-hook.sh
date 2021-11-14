# shellcheck shell=bash
ld-is-cc-hook() {
    LD=$CC
}

preConfigureHooks+=(ld-is-cc-hook)
