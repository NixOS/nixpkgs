# maxOS Sequoia 15.4 updated their link-loader to refuse to evaluate
# dylibs that include duplciate LC_RPATH instructions. Some libraries
# haven't properly fixed this yet, and some internal NixOS builds seem
# to cause this type of issue to occur. This hook simply cleans up any
# duplicates detected inside dylib files.

fixupOutputHooks+=('fixDarwinDuplicateRpathsIn $prefix')

removeDarwinDuplicateRpaths() {
    dylib_path=$1
    duplicates=$(@targetPrefix@otool -l "$dylib_path" | awk '/cmd LC_RPATH/{getline; getline; paths[$2]+=1} END { for (p in paths) if (paths[p]>1) print p }')
    if [ -n "$duplicates" ]; then
        echo "$dylib_path: removing duplicates"
        echo "$duplicates"
        while IFS= read -r dup; do
            @targetPrefix@install_name_tool $dylib_path -delete_rpath "$dup"
        done <<< "$duplicates"
    fi
}

fixDarwinDuplicateRpathsIn() {
    local dir="$1"
    dirs=$(find $dir -name "*.dylib")
    if [ -n "$dirs" ]; then
        while IFS= read -r dylib_path; do
            removeDarwinDuplicateRpaths $dylib_path
        done <<< "$dirs"
    fi
}
