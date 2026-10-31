# Minimal `xxd --include` replacement for embedding binary files as C arrays.
# Used instead of tinyxxd to avoid ~22k rebuilds via libaom -> ffmpeg -> everything.
{ writeShellScriptBin }:

writeShellScriptBin "xxd" ''
  if [ "$1" != "--include" ]; then
    echo "xxd: only --include mode is supported" >&2
    exit 1
  fi
  input="$2"
  output="$3"
  # Match real xxd behavior: derive variable name from the full path
  varname=$(echo "$input" | sed 's/[^a-zA-Z0-9_]/_/g')
  {
    printf 'unsigned char %s[] = {\n' "$varname"
    od -An -tx1 -v "$input" | sed 's/  */ /g; s/^ //; s/ $//; s/ /, 0x/g; s/^/  0x/; s/$/,/'
    printf '};\n'
    printf 'unsigned int %s_len = %d;\n' "$varname" "$(wc -c < "$input")"
  } > "$output"
''
