# symlinks are often created in postFixup
# don't use fixupOutputHooks, it is before postFixup
postFixupHooks+=(_makeSymlinksRelativeInAllOutputs)

# For every symlink in $output that refers to another file in $output
# ensure that the symlink is relative. This removes references to the output
# has from the resulting store paths and thus the NAR files.
_makeSymlinksRelative() {
    local symlinkTarget

    if [ "${dontRewriteSymlinks-}" ] || [ ! -e "$prefix" ]; then
       return
    fi

    while IFS= read -r -d $'\0' f; do
        symlinkTarget=$(readlink "$f")
        if [[ "$symlinkTarget"/ != "$prefix"/* ]]; then
            # skip this symlink as it doesn't point to $prefix
            continue
        fi

        if [ ! -e "$symlinkTarget" ]; then
            echo "the symlink $f is broken, it points to $symlinkTarget (which is missing)"
        fi

        echo "rewriting symlink $f to be relative to $prefix"
        ln -snrf "$symlinkTarget" "$f"

    done < <(find $prefix -type l -print0)
}

_makeSymlinksRelativeInAllOutputs() {
  local output
  for output in $(getAllOutputNames); do
    prefix="${!output}" _makeSymlinksRelative
  done
}
