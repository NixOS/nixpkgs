lzipUnpackCmdHook() {
    [[ "$1" = *.tar.lz ]] && tar --lzip -xf "$1"
}

unpackCmdHooks+=(lzipUnpackCmdHook)
