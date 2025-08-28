findTarball() {
    local suffix i
    if [ -d "$1/tarballs/" ]; then
        for suffix in tar.gz tgz tar.bz2 tbz2 tbz tar.xz txz tar.lzma; do
            for i in $1/tarballs/*.$suffix; do echo $i; break; done
        done | sort | head -1
        return
    else
        echo "$1"
        return
    fi
}

propagateImageName() {
    mkdir -p $out/nix-support
    cat "$diskImage"/nix-support/full-name > $out/nix-support/full-name
}
