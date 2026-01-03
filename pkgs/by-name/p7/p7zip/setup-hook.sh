unpackCmdHooks+=(_try7zip)
_try7zip() {
    if ! [[ "$curSrc" =~ \.7z$ ]]; then return 1; fi
    7z x "$curSrc"
}
