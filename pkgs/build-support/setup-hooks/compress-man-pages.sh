fixupOutputHooks+=('if [ -z "$dontGzipMan" ]; then compressManPages "$prefix"; fi')

compressManPages() {
    local dir="$1"

    if [[ ! -d "$dir/share/man" ]]; then return; fi
    echo "gzipping man pages in $dir"

    # compress all uncompressed manpages
    for f in "$dir"/share/man/*/* "$dir"/share/man/*/*/*; do
        if [[ ! "$f" =~ .(bz2|gz)$ ]]  && [[ -f "$f" ]] && [[ ! -L "$f" ]]; then
            if gzip -c -n "$f" > "$f".gz; then
                rm "$f"
            else
                rm "$f".gz
            fi
        fi
    done

    # point symlinks to compressed manpages
    for f in "$dir"/share/man/*/* "$dir"/share/man/*/*/*; do
        if [[ ! "$f" =~ .(bz2|gz)$ ]] && [[ -L "$f" ]]; then
            local target="$(readlink -f "$f")"
            if [[ -f "$target".gz ]]; then
                ln -sf "$target".gz "$f".gz && rm "$f"
            fi
        fi
    done
}
