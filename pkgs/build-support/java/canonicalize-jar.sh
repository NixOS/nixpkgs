# Canonicalize the manifest & repack with deterministic timestamps.
canonicalizeJar() {
    local input="$1"
    echo "canonicalizing $input"
    # -q|--quiet
    # -F|--fix: fixes archive when it has some small problems
    @zip@ -qF "$input" --out "$input.fix"
    # -qq: even quieter
    # -o: overrides existing files (when there are overlapping files in the archive)
    @unzip@ -qqo "$input.fix" -d "$input-tmp"
    rm "$input" "$input.fix"
    pushd "$input-tmp" >/dev/null
    # Sets all timestamps to Jan 1 1980, the earliest mtime zips support.
    find . -exec touch -t 198001010000.00 {} +
    # -q|--quiet, -r|--recurse-paths
    # -o|--latest-time: canonicalizes overall archive mtime
    # -X|--no-extra: don't store platform-specific extra file attribute fields
    @zip@ -qroX "$input" .
    popd >/dev/null
    rm -rf "$input-tmp"
}

