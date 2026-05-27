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
  find "${prefixes[@]}" -type l -printf '%H\0%p\0' \
    | xargs -0 -n2 -r -P "$NIX_BUILD_CORES" sh -c '
      output="$1"
      link="$2"

      linkTarget=$(readlink "$link")

      # only touch links that point inside the same output tree
      [[ $linkTarget == "$output"/* ]] || exit 0

      if [ ! -e "$linkTarget" ]; then
        echo "the symlink $link is broken, it points to $linkTarget (which is missing)"
      fi

      echo "making symlink relative: $link"
      ln -snrf "$linkTarget" "$link"
    ' _
}
