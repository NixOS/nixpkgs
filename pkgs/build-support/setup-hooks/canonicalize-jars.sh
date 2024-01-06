# This setup hook causes the fixup phase to repack all JAR files in a
# canonical & deterministic fashion, e.g. resetting mtimes (like with normal
# store files) and avoiding impure metadata.

fixupOutputHooks+=('if [ -z "$dontCanonicalizeJars" -a -e "$prefix" ]; then canonicalizeJarsIn "$prefix"; fi')

canonicalizeJarsIn() {
  local dir="$1"
  echo "canonicalizing jars in $dir"
  find $dir -type f -name '*.jar' -print0 |
  while IFS= read -rd '' f; do
    canonicalizeJar "$f"
  done
}

source @canonicalize_jar@
