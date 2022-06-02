#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/tarball/21.11 -i bash -p pandoc

# This script is temporarily needed while we transition the manual to
# CommonMark. It converts the .md files in the regular manual folder
# into DocBook files in the from_md folder.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd "$DIR"

# NOTE: Keep in sync with Nixpkgs manual (/doc/Makefile).
# TODO: Remove raw-attribute when we can get rid of DocBook altogether.
pandoc_commonmark_enabled_extensions=+attributes+fenced_divs+footnotes+bracketed_spans+definition_lists+pipe_tables+raw_attribute
pandoc_flags=(
  # Not needed:
  # - diagram-generator.lua (we do not support that in NixOS manual to limit dependencies)
  # - media extraction (was only required for diagram generator)
  # - docbook-reader/citerefentry-to-rst-role.lua (only relevant for DocBook → MarkDown/rST/MyST)
  "--lua-filter=$DIR/../../../doc/build-aux/pandoc-filters/myst-reader/roles.lua"
  "--lua-filter=$DIR/../../../doc/build-aux/pandoc-filters/link-unix-man-references.lua"
  "--lua-filter=$DIR/../../../doc/build-aux/pandoc-filters/docbook-writer/rst-roles.lua"
  "--lua-filter=$DIR/../../../doc/build-aux/pandoc-filters/docbook-writer/labelless-link-is-xref.lua"
  -f "commonmark${pandoc_commonmark_enabled_extensions}+smart"
  -t docbook
)

OUT="$DIR/from_md"
mapfile -t MD_FILES < <(find . -type f -regex '.*\.md$')

for mf in ${MD_FILES[*]}; do
  if [ "${mf: -11}" == ".section.md" ]; then
    mkdir -p "$(dirname "$OUT/$mf")"
    OUTFILE="$OUT/${mf%".section.md"}.section.xml"
    pandoc "$mf" "${pandoc_flags[@]}" \
      -o "$OUTFILE"
    grep -q -m 1 "xi:include" "$OUTFILE" && sed -i 's|xmlns:xlink="http://www.w3.org/1999/xlink"| xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude"|' "$OUTFILE"
  fi

  if [ "${mf: -11}" == ".chapter.md" ]; then
    mkdir -p "$(dirname "$OUT/$mf")"
    OUTFILE="$OUT/${mf%".chapter.md"}.chapter.xml"
    pandoc "$mf" "${pandoc_flags[@]}" \
      --top-level-division=chapter \
      -o "$OUTFILE"
    grep -q -m 1 "xi:include" "$OUTFILE" && sed -i 's|xmlns:xlink="http://www.w3.org/1999/xlink"| xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude"|' "$OUTFILE"
  fi
done

popd
