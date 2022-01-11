# Canonicalize the manifest & repack with deterministic timestamps.
canonicalizeJar() {
    local input='' outer=''
    input="$(realpath -sm -- "$1")"
    outer="$(pwd)"
    # -qq: even quieter
    @unzip@ -qq "$input" -d "$input-tmp"
    canonicalizeJarManifest "$input-tmp/META-INF/MANIFEST.MF"
    # Sets all timestamps to Jan 1 1980, the earliest mtime zips support.
    find -- "$input-tmp" -exec touch -t 198001010000.00 {} +
    rm "$input"
    pushd "$input-tmp" 2>/dev/null
    # -q|--quiet, -r|--recurse-paths
    # -o|--latest-time: canonicalizes overall archive mtime
    # -X|--no-extra: don't store platform-specific extra file attribute fields
    @zip@ -qroX "$outer/tmp-out.jar" . 2> /dev/null
    popd 2>/dev/null
    rm -rf "$input-tmp"
    mv "$outer/tmp-out.jar" "$input"
}

# See also the Java specification's JAR requirements:
# https://docs.oracle.com/javase/8/docs/technotes/guides/jar/jar.html#Notes_on_Manifest_and_Signature_Files
canonicalizeJarManifest() {
    local input=''
    input="$(realpath -sm -- "$1")"
    (head -n 1 "$input" && tail -n +2 "$input" | sort | grep -v '^\s*$') > "$input-tmp"
    mv "$input-tmp" "$input"
}
