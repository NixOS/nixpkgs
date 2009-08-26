#! /bin/sh

set -x

own_dir="$(cd "$(dirname "$0")"; sh -c pwd)"

source "$own_dir/snippets.sh"

main_file="$1"
main_dir="$(cd "$(dirname "$main_file")" ; sh -c pwd)"
file_name="$(basename "$main_file")"
defs_file="$main_dir"/src-info-for-"$file_name"
src_file="$main_dir"/src-for-"$file_name"
# OK, [vcs] revert is always possible
new_src_file="$main_dir"/src-for-"$file_name"

forcedUrl="$2"

defs_dir="$("$own_dir"/attrset-to-dir.sh "$defs_file")"
src_defs_dir="$("$own_dir"/attrset-to-dir.sh "$src_file")"

getAttr () {
    file="$defs_dir"/"$1"
    data="$( ( [ -f "$file" ] && cat "$file" ) || echo "$2" )"
    echo "attribute $1 obtained as: [[$data]]" >&2
    echo "$data"
}

if [ -z "$forcedUrl" ] ; then
    freshUrl="$("$own_dir"/urls-from-page.sh "$(getAttr downloadPage)" |
      eval "egrep \"$(getAttr sourceRegexp '.*[.]tar[.].*')\"" | 
      eval "$(getAttr choiceCommand 'head -1')")"

    if ! egrep ':' freshUrl ; then 
	    freshUrl="$(dirname "$(getAttr downloadPage).")/$freshUrl"
    fi

    echo "Found download link: $freshUrl" >&2
else
    freshUrl="$forcedUrl"
fi

if [ x"$freshUrl" = x"$(cat "$src_defs_dir"/advertisedUrl)" ]; then
    echo "Source link not changed" >&2
    exit
fi

version="$(echo "$freshUrl" | 
  eval "sed -re \"$(getAttr versionExtractorSedScript \
    's/.*-([0-9.]+)[.].*/\1/')\"")"

mirrorUrl="$(echo "$freshUrl" | 
  eval "sed -r -e \"$(getAttr versionReferenceCreator \
    's/-([0-9.]+)[.]/-${version}./')\"" |
  eval "sed -r -e \"$(getAttr mirrorSedScript)\"")"

hash=$(nix-prefetch-url "$freshUrl")

baseName="$(getAttr baseName 'unnamed-package')"
name="$baseName-$version"

advertisedUrl="$freshUrl"
url="$mirrorUrl"

extraAssignments=""
for i in $(getAttr extraVars ''); do
  eval "$(getAttr "eval_$i" 'i=""')"
  extraAssignments="$extraAssignments $i=\"$(eval echo \"\$$i\")\";"
done

cat << EOF > "$new_src_file"
rec {
  advertisedUrl="$advertisedUrl";
  version = "$version";
  url="$url";
  hash = "$hash";
  name = "$name";
  $extraAssignments
}
EOF
