findTarballs() {
    local suffix
    test -d "$1/tarballs/" && {
        for suffix in tar.gz tgz tar.bz2 tbz2 tar.xz tar.lzma; do
            ls $1/tarballs/*.$suffix 2> /dev/null
        done | sort
    }
    echo "$1"
}

propagateImageName() {
    mkdir -p $out/nix-support
    cat "$diskImage"/nix-support/full-name > $out/nix-support/full-name
}
