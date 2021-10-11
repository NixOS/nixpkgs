unpackCmdHooks+=(_tryUnzipVsix)
_tryUnzipVsix() {
    if ! [[ "$curSrc" =~ \.(vsix|VSIX)$ ]]; then return 1; fi
    unzip -qq "$curSrc"
}
