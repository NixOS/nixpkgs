#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=channel:nixpkgs-unstable -i bash -p pandoc

# This script is temporarily needed while we transition the manual to
# CommonMark. It converts the .md files in the regular manual folder
# into DocBook files in the from_md folder.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

OUT="$DIR/from_md"
mapfile -t MD_FILES < <(find . -type f -regex '.*\.md$')

for mf in ${MD_FILES[*]}; do
  if [ "${mf: -11}" == ".section.md" ]; then
    mkdir -p $(dirname "$OUT/$mf")
    pandoc "$mf" -t docbook \
      --extract-media=media \
      -f markdown+smart \
    | cat  > "$OUT/${mf%".section.md"}.section.xml"
  fi

  if [ "${mf: -11}" == ".chapter.md" ]; then
    mkdir -p $(dirname "$OUT/$mf")
    pandoc "$mf" -t docbook \
      --top-level-division=chapter \
      --extract-media=media \
      -f markdown+smart \
    | cat  > "$OUT/${mf%".chapter.md"}.chapter.xml"
  fi
done

popd
