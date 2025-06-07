# symlinks are often created in postFixup
# don't use fixupOutputHooks, it is before postFixup
if [[ -z "${dontRewriteSymlinks-}" ]]; then
  postFixupHooks+=(_makeSymlinksRelative)
fi


# For every symlink in $output that refers to another file in $output
# ensure that the symlink is relative.
# This increases the chance that NAR files can be deduplicated.
_makeSymlinksRelative() {
  local prefixes
  prefixes=()
  for output in $(getAllOutputNames); do
    [ ! -e "${!output}" ] && continue
    prefixes+=( "${!output}" )
  done

  # Process a single symlink
  _processSymlink() {
    local entry="$1"
    # Split on newline: first line is output, second line is link
    local output="${entry%%$'\n'*}"
    local link="${entry#*$'\n'}"

    linkTarget=$(readlink "$link")

    # only touch links that point inside the same output tree
    [[ $linkTarget == "$output"/* ]] || return 0

    if [ ! -e "$linkTarget" ]; then
      echo "the symlink $link is broken, it points to $linkTarget (which is missing)"
    fi

    echo "making symlink relative: $link"
    ln -snrf "$linkTarget" "$link"
  }

  find "${prefixes[@]}" -type l -printf '%H\n%p\0' \
    | parallelMap _processSymlink

  unset -f _processSymlink
}
