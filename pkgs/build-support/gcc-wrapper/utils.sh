skip () {
    if test "$NIX_DEBUG" = "1"; then
        echo "skipping impure path $1" >&2
    fi
}

badPath() {
    local p=$1
    test \
        "${p:0:${#NIX_STORE}}" != "$NIX_STORE" -a \
        "${p:0:4}" != "/tmp" -a \
        "${p:0:${#NIX_BUILD_TOP}}" != "$NIX_BUILD_TOP"
}
