unpackCmdHooks+=(_tryUnpack7z _tryUnpackDmg)
_tryUnpack7z() {
    if ! [[ "$curSrc" =~ \.7z$ ]]; then return 1; fi
    # silence ouput and progress logging via -bs and -bd
    # can not restrict extract to $NIX_BUILD_CORES
    # https://sourceforge.net/p/sevenzip/discussion/45797/thread/7d1b080ceb/
    7zz x "$curSrc" -y -bso0 -bd
}

_tryUnpackDmg() {
    if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
    7zz x "$curSrc"
}
