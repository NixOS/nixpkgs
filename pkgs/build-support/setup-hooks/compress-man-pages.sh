fixupOutputHooks+=('if [ -z "${dontGzipMan-}" ]; then compressManPages "$prefix"; fi')

compressManPages() {
    local dir="$1"

    if [ -L "$dir"/share ] || [ -L "$dir"/share/man ] || [ ! -d "$dir/share/man" ]
        then return
    fi
    echo "gzipping man pages under $dir/share/man/"

    # Compress all uncompressed manpages.  Don't follow symlinks, etc.
    # gzip -f is needed to not error out on hard links.
    find "$dir"/share/man/ -type f -a '!' -regex '.*\.\(bz2\|gz\|xz\)$' -print0 \
        | xargs -0 -n1 -P "$NIX_BUILD_CORES" gzip -n -f

    # Point symlinks to compressed manpages.
    find "$dir"/share/man/ -type l -a '!' -regex '.*\.\(bz2\|gz\|xz\)$' -print0 \
        | sort -z \
        | while IFS= read -r -d $'\0' f
    do
        local target
        target="$(readlink -f "$f")"
        if [ -f "$target".gz ]; then
            ln -sf "$target".gz "$f".gz && rm "$f"
        fi
    done
}
