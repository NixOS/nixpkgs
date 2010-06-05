#! /bin/sh

set -x

own_dir="$(cd "$(dirname "$0")"; sh -c pwd)"

source "$own_dir/snippets.sh"

[ -z "$1" ] && {
  echo "Specify main expression filename."
  exit 1;
}

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

method="$(getAttr method fetchurl)"
baseName="$(getAttr baseName 'unnamed-package')"
commonPrefetchVars=" version name hash"

prefetchClause=""
[ fetchurl = "$method" ] && {
    if [ -z "$forcedUrl" ] ; then
        freshUrl="$("$own_dir"/urls-from-page.sh "$(getAttr downloadPage)" |
          eval "egrep \"$(getAttr sourceRegexp '.*[.]tar[.].*')\"" | 
	  eval "egrep -v \"$(getAttr blacklistRegexp '^$')\"" |
          eval "$(getAttr choiceCommand 'head -1')")"
    
        if ! egrep ':' <<< "$freshUrl" ; then 
    	    freshUrl="$(dirname "$(getAttr downloadPage).")/$freshUrl"
        fi
    
        echo "Found download link: $freshUrl" >&2
    else
        freshUrl="$forcedUrl"
    fi
    
    version="$(echo "$freshUrl" | 
      eval "sed -re \"$(getAttr versionExtractorSedScript \
        's/.*-([0-9.]+)[.].*/\1/')\"")"
    
    mirrorUrl="$(echo "$freshUrl" | 
      eval "sed -r -e \"$(getAttr versionReferenceCreator \
        's/-'"${version}"'[.]/-\${version}./')\"" |
      eval "sed -r -e \"$(getAttr mirrorSedScript)\"")"
    url="$mirrorUrl"
    
    name="$baseName-$version"
    
    advertisedUrl="$freshUrl"
    url="$mirrorUrl"
    
    if [ x"$freshUrl" = x"$(cat "$src_defs_dir"/advertisedUrl)" ]; then
        echo "Source link not changed" >&2
        exit
    fi
    hash=$(nix-prefetch-url "$freshUrl")

    prefetchVars="url advertisedUrl";
}
[ "fetchgit" = "$method" ] && {
    repoUrl="$(getAttr repoUrl)"
    export NIX_PREFETCH_GIT_CHECKOUT_HOOK="
        cat .git/HEAD
    "
    export NIX_HASH_ALGO=sha256
    rev="$(getAttr rev '')";
    rev_and_hash="$("$own_dir"/../fetchgit/nix-prefetch-git "$repoUrl" "$rev" | tee /dev/stderr | tail -2)"

    rev="$(echo "$rev_and_hash" | head -1)"
    url="$repoUrl";
    hash="$(echo "$rev_and_hash" | tail -1)"
    version="$rev"
    name="$baseName-$version"

    prefetchVars="rev url";
}

prefetchAssignments="";
for i in $commonPrefetchVars $prefetchVars; do
  prefetchAssignments="$prefetchAssignments $i=\"$(eval echo \"\$$i\")\";$(echo -e '\n  ')"
done;

extraAssignments=""
for i in $(getAttr extraVars ''); do
  eval "$(getAttr "eval_$i" 'i=""')"
  extraAssignments="$extraAssignments $i=\"$(eval echo \"\$$i\")\";$(echo -e '\n  ')"
done

cat << EOF > "$new_src_file"
rec {
  $prefetchAssignments
  $extraAssignments
}
EOF
