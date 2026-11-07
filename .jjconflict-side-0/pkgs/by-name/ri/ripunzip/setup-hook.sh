unpackCmdHooks+=(_tryRipunzip)
_tryRipunzip() {
    ripunzip unzip-file "$curSrc" 2> /dev/null
}
