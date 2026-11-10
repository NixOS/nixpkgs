isPE() {
  local fd
  local magic
  exec {fd}< "$1"
  LANG=C read -r -n 2 -u "$fd" magic
  exec {fd}<&-
  if [[ $magic == MZ ]]; then
    # Let’s just assume this isn’t a DOS executable…
    return 0
  else
    return 1
  fi
}

authenticodeCheckHook() {
  local excludeFlags=()
  for pattern in "${authenticodeCheckExclude[@]}"; do
    excludeFlags+=(
      -a '!' '(' -name "$pattern" -o -wholename "$prefix/$pattern" ')'
    )
  done

  local checked=

  while read -rd '' file; do
    if isPE "$file"; then
      checked=1
      "@pesigcheck@" \
        --no-system-db=0 \
        --certfile="$authenticodeCertificate" \
        --in="$file"
    fi
  done < <(find -L -- "$prefix" -type f "${excludeFlags[@]}" -print0)

  if [[ -z $checked ]]; then
    nixErrorLog 'no PE files found'
    exit 1
  fi
}

fixupOutputHooks+=(authenticodeCheckHook)
