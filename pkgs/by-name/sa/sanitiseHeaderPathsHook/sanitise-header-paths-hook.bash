sanitiseHeaderPaths() {
  local header
  while IFS= read -r -d '' header; do
    nixLog "sanitising header path in $header"
    sed -i "1i#line 1 \"$header\"" "$header"
    @removeReferencesTo@ -t "${!outputInclude}" "$header"
  done < <(find "${!outputInclude}/include" -type f -print0)
}

preFixupHooks+=(sanitiseHeaderPaths)
