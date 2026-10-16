lzipUnpackCmdHook() {
    tar --lzip -xf "$1"
}

unpackCmdHooks+=(lzipUnpackCmdHook)
