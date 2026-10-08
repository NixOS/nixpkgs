unpackCmdHooks+=(_tryUnpackDmg)
_tryUnpackDmg() {
    if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
    7zz x "$curSrc"
}
