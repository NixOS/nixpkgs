fixupOutputHooks+=('if [ -z "$dontGzipMan" ]; then compressManPages "$prefix"; fi')

compressManPages() {
    local dir="$1"

    if [ ! -d "$dir/share/man" ]; then return; fi
    echo "gzipping man pages in $dir"

    GLOBIGNORE=.:..:*.gz:*.bz2

    for f in "$dir"/share/man/*/* "$dir"/share/man/*/*/*; do
        if [ -f "$f" -a ! -L "$f" ]; then
            if gzip -c -n "$f" > "$f".gz; then
                rm "$f"
            else
                rm "$f".gz
            fi
        fi
    done

    for f in "$dir"/share/man/*/* "$dir"/share/man/*/*/*; do
        if [ -L "$f" -a -f `readlink -f "$f"`.gz ]; then
            ln -sf `readlink "$f"`.gz "$f".gz && rm "$f"
        fi
    done

    unset GLOBIGNORE
}
