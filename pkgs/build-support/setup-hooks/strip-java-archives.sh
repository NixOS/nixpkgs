# This setup hook makes the fixup phase to repack all java archives in a
# deterministic fashion. The most important change being done is the resetting
# of the modification times of the archive entries

fixupOutputHooks+=('stripJavaArchivesIn $prefix')

stripJavaArchivesIn() {
    local dir="$1"
    echo "stripping java archives in $dir"
    find $dir -type f -regextype posix-egrep -regex ".*\.(jar|war|hpi|apk)$" -print0 |
    while IFS= read -rd '' f; do
        echo "stripping java archive $f"
        strip-nondeterminism --type jar "$f"
    done
}

