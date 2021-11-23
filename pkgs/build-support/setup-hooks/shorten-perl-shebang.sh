# shellcheck shell=bash
# This setup hook modifies a Perl script so that any "-I" flags in its shebang
# line are rewritten into a "use lib ..." statement on the next line. This gets
# around a limitation in Darwin, which will not properly handle a script whose
# shebang line exceeds 511 characters.
#
# Each occurrence of "-I /path/to/lib1" or "-I/path/to/lib2" is removed from
# the shebang line, along with the single space that preceded it. These library
# paths are placed into a new line of the form
#
#     use lib "/path/to/lib1", "/path/to/lib2";
#
# immediately following the shebang line. If a library appeared in the original
# list more than once, only its first occurrence will appear in the output
# list. In other words, the libraries are deduplicated, but the ordering of the
# first appearance of each one is preserved.
#
# Any flags other than "-I" in the shebang line are left as-is, and the
# interpreter is also left alone (although the script will abort if the
# interpreter does not seem to be either "perl" or else "env" with "perl" as
# its argument). Each line after the shebang line is left unchanged. Each file
# is modified in place.
#
# Usage:
#     shortenPerlShebang SCRIPT...

shortenPerlShebang() {
    while [ $# -gt 0 ]; do
        _shortenPerlShebang "$1"
        shift
    done
}

_shortenPerlShebang() {
    local program="$1"

    echo "shortenPerlShebang: rewriting shebang line in $program"

    if ! isScript "$program"; then
        die "shortenPerlShebang: refusing to modify $program because it is not a script"
    fi

    local temp="$(mktemp)"

    gawk '
        (NR == 1) {
            if (!($0 ~ /\/(perl|env +perl)\>/)) {
                print "shortenPerlShebang: script does not seem to be a Perl script" > "/dev/stderr"
                exit 1
            }
            idx = 0
            while (match($0, / -I ?([^ ]+)/, pieces)) {
                matches[idx] = pieces[1]
                idx++
                $0 = gensub(/ -I ?[^ ]+/, "", 1, $0)
            }
            print $0
            if (idx > 0) {
                prefix = "use lib "
                for (idx in matches) {
                    path = matches[idx]
                    if (!(path in seen)) {
                        printf "%s\"%s\"", prefix, path
                        seen[path] = 1
                        prefix = ", "
                    }
                }
                print ";"
            }
        }
        (NR > 1 ) {
            print
        }
    ' "$program" > "$temp" || die
    # Preserve the mode of the original file
    cp --preserve=mode --attributes-only "$program" "$temp"
    mv "$temp" "$program"

    # Measure the new shebang line length and make sure it's okay. We subtract
    # one to account for the trailing newline that "head" included in its
    # output.
    local new_length=$(( $(head -n 1 "$program" | wc -c) - 1 ))

    # Darwin is okay when the shebang line contains 511 characters, but not
    # when it contains 512 characters.
    if [ $new_length -ge 512 ]; then
        die "shortenPerlShebang: shebang line is $new_length characters--still too long for Darwin!"
    fi
}
