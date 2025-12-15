unpackCmdHooks+=(_tryRipunzip)
_tryRipunzip() {
    if ! [[ "$curSrc" =~ \.zip$ ]]; then return 1; fi

    ripunzip unzip-file "$curSrc" 2> /dev/null
}
