unpackCmdHooks+=(_tryBsdtar)
_tryBsdtar() {
    if ! [[ "$(file -b --mime-type "$curSrc")" = "application/zip" ]]; then return 1; fi

    bsdtar xf "$curSrc"
}
