#! /bin/sh

export LANG=C LC_ALL=C LC_COLLATE=C

# Load git log
raw_git_log="$(git log)"
git_data="$(echo "$raw_git_log" | grep 'Author:' |
  sed -e 's/^ *Author://; s/\\//g; s/^ *//; s/ *$//;
  s/ @ .*//; s/ *[<]/\t/; s/[>]//')"

# Name - nick - email correspondence from log and from maintainer list
# Also there are a few manual entries
maintainers="$(cat "$(dirname "$0")/../maintainer-list.nix" |
  grep '=' | sed -re 's/\\"/''/g;
  s/[ 	]*([^ 	=]*)[ 	]*=[ 	]*" *(.*[^ ]) *[<](.*)[>] *".*/\1\t\2\t\3/')"
git_lines="$( ( echo "$git_data";
    cat "$(dirname "$0")/vanity-manual-equalities.txt") | sort |uniq)"

emails="$(
    ( echo "$maintainers" | cut -f 3; echo "$git_data" | cut -f 2 ) |
    sort | uniq | grep -E ".+@.+[.].+"
    )"

fetchGithubName () {
    commitid="$(
        echo "$raw_git_log" | grep -B3 "Author: .*[<]$1[>]" | head -n 3 |
            grep '^commit ' | tail -n 1 | sed -e 's/^commit //'
    )"
    userid="$(
        curl https://github.com/NixOS/nixpkgs/commit/"$commitid" 2>/dev/null |
        grep committed -B10 | grep 'href="/' |
        sed -re 's@.* href="/@@; s@".*@@' |
        grep -v "/commit/"
    )";
    echo "$userid"
}

[ -n "$NIXPKGS_GITHUB_NAME_CACHE" ] && {
    echo "$emails" | while read email; do
        line="$(grep "$email	" "$NIXPKGS_GITHUB_NAME_CACHE")"
        [ -z "$line" ] && {
            echo "$email	$(fetchGithubName "$email")" >> \
                "$NIXPKGS_GITHUB_NAME_CACHE"
        }
    done
}

# For RDF
normalize_name () {
    sed -e 's/%/%25/g; s/ /%20/g; s/'\''/%27/g; s/"/%22/g; s/`/%60/g; s/\^/%5e/g; '
}

denormalize_name () {
    sed -e 's/%20/ /g; s/%27/'\''/g; s/%22/"/g; s/%60/`/g; s/%5e/^/g; s/%25/%/g;';
}

n3="$(mktemp --suffix .n3)"

# «The same person» relation and a sorting hint
# Full name is something with a space
(
echo "$git_lines" | sed -re 's@(.*)\t(.*)@<my://name/\1>	<my://can-be>	<my://name/\2>.@'
echo "$git_lines" | sed -re 's@(.*)\t(.*)@<my://name/\2>	<my://can-be>	<my://name/\1>.@'
echo "$maintainers" | sed -re 's@(.*)\t(.*)\t(.*)@<my://name/\1>	<my://can-be>	<my://name/\2>.@'
echo "$maintainers" | sed -re 's@(.*)\t(.*)\t(.*)@<my://name/\2>	<my://can-be>	<my://name/\3>.@'
echo "$maintainers" | sed -re 's@(.*)\t(.*)\t(.*)@<my://name/\3>	<my://can-be>	<my://name/\1>.@'
echo "$git_lines" | grep ' ' | cut -f 1 | sed -e 's@.*@<my://name/&>	<my://is-name>	<my://0>.@'
echo "$git_lines" | grep -v ' ' | cut -f 1 | sed -e 's@.*@<my://name/&>	<my://is-name>	<my://1>.@'
echo "$maintainers" | cut -f 2 | sed -e 's@.*@<my://name/&>	<my://is-name>	<my://0>.@'
[ -n "$NIXPKGS_GITHUB_NAME_CACHE" ] && cat "$NIXPKGS_GITHUB_NAME_CACHE" |
    grep -v "	$" |
    sed -re 's@(.*)\t(.*)@<my://name/\1>	<my://at-github>	<my://github/\2>.@'
) | normalize_name | grep -E '<my://[-a-z]+>' | sort | uniq > "$n3"

# Get transitive closure
sparql="$(nix-build '<nixpkgs>' -Q -A apache-jena --no-out-link)/bin/sparql"
name_list="$(
    "$sparql" --results=TSV --data="$n3" "
    select ?x ?y ?g where {
      ?x <my://can-be>+ ?y.
      ?x <my://is-name> ?g.
        }
    " | tail -n +2 |
    sed -re 's@<my://name/@@g; s@<my://@@g; s@>@@g;' |
    sort -k 2,3 -t '	'
)"
github_name_list="$(
    "$sparql" --results=TSV --data="$n3" "
    select ?x ?y where {
      ?x (<my://can-be>+ / <my://at-github>) ?y.
        }
    " | tail -n +2 |
    sed -re 's@<my://(name|github)/@@g; s@<my://@@g; s@>@@g;'
)"

# Take first spelling option for every person
name_list_canonical="$(echo "$name_list" | cut -f 1,2 | uniq -f1)"

cleaner_script="$(echo "$name_list_canonical" | denormalize_name |
  sed -re 's/(.*)\t(.*)/s#^\2$#\1#g/g')"

# Add github usernames
if [ -n "$NIXPKGS_GITHUB_NAME_CACHE" ]; then
    github_adder_script="$(mktemp)"
    echo "$github_name_list" |
        grep -E "$(echo "$name_list_canonical" | cut -f 2 |
        tr '\n' '|' )" |
    sort | uniq |
        sed -re 's/(.*)\t(.*)/s| \1$| \1\t\2|g;/' |
    denormalize_name > "$github_adder_script"
else
    github_adder_script='/dev/null'
fi

echo "$name_list" | denormalize_name

echo

echo "$git_data" | cut -f 1 |
    sed -e "$cleaner_script" |
    sort | uniq -c | sort -k1n | sed -rf "$github_adder_script" |
    sed -re 's/^ *([0-9]+) /\1\t/'
