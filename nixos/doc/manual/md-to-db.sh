#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=channel:nixpkgs-unstable -i bash -p pandoc

# This script is temporarily needed while we transition the manual to
# CommonMark. It converts the .md files in the regular manual folder
# into DocBook files in the from_md folder.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

# NOTE: Keep in sync with Nixpkgs manual (/doc/Makefile).
# TODO: Remove raw-attribute when we can get rid of DocBook altogether.
pandoc_commonmark_enabled_extensions=+attributes+fenced_divs+footnotes+bracketed_spans+definition_lists+pipe_tables+raw_attribute
pandoc_flags=(
  # media extraction and diagram-generator.lua not needed
  "--lua-filter=$DIR/../../../doc/labelless-link-is-xref.lua"
  -f "commonmark${pandoc_commonmark_enabled_extensions}+smart"
  -t docbook
)

OUT="$DIR/from_md"
mapfile -t MD_FILES < <(find . -type f -regex '.*\.md$')

for mf in ${MD_FILES[*]}; do
  if [ "${mf: -11}" == ".section.md" ]; then
    mkdir -p $(dirname "$OUT/$mf")
    pandoc "$mf" "${pandoc_flags[@]}" \
      -o "$OUT/${mf%".section.md"}.section.xml"
  fi

  if [ "${mf: -11}" == ".chapter.md" ]; then
    mkdir -p $(dirname "$OUT/$mf")
    pandoc "$mf" "${pandoc_flags[@]}" \
      --top-level-division=chapter \
      -o "$OUT/${mf%".chapter.md"}.chapter.xml"
  fi
done

popd
