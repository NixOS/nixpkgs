fixupOutputHooks+=('if [ -z "$dontGzipMan" ]; then compressManPages "$prefix"; fi')

compressManPages() {
    local dir="$1"

    if [ -L "$dir"/share ] || [ -L "$dir"/share/man ] || [ ! -d "$dir/share/man" ]
        then return
    fi
    echo "gzipping man pages under $dir/share/man/"

    # Compress all uncompressed manpages.  Don't follow symlinks, etc.
    find "$dir"/share/man/ -type f -a '!' -regex '.*\.\(bz2\|gz\)$' -print0 \
        | while IFS= read -r -d $'\0' f
    do
        if gzip -c -n "$f" > "$f".gz; then
            rm "$f"
        else
            rm "$f".gz
        fi
    done

    # Point symlinks to compressed manpages.
    find "$dir"/share/man/ -type l -a '!' -regex '.*\.\(bz2\|gz\)$' -print0 \
        | while IFS= read -r -d $'\0' f
    do
        local target
        target="$(readlink -f "$f")"
        if [ -f "$target".gz ]; then
            ln -sf "$target".gz "$f".gz && rm "$f"
        fi
    done
}
