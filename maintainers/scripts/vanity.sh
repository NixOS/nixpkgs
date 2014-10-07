#! /bin/sh

export LANG=C LC_ALL=C LC_COLLATE=C

# Load git log
git_data="$(git log | grep 'Author:' | 
  sed -e 's/^ *Author://; s/\\//g; s/^ *//; s/ *$//; 
  s/ @ .*//; s/ *[<]/\t/; s/[>]//')"

# Name - nick - email correspondence from log and from maintainer list
# Also there are a few manual entries
maintainers="$(cat "$(dirname "$0")/../../lib/maintainers.nix" | 
  grep '=' | sed -re 's/\\"/''/g;
  s/ *([^ =]*) *= *" *(.*[^ ]) *[<](.*)[>] *".*/\1\t\2\t\3/')"
git_lines="$( ( echo "$git_data"; 
    cat "$(dirname "$0")/vanity-manual-equalities.txt") | sort |uniq)"

# For RDF
normalize_name () {
	sed -e 's/ /_/g; s/'\''/*/g; s/"/**/g;'
}

denormalize_name () {
	sed -e 's/_/ /g; s/[*][*]/"/g; s/[*]/'\''/g;'
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

# Take first spelling option for every person
name_list_canonical="$(echo "$name_list" | cut -f 1,2 | uniq -f1)"

cleaner_script="$(echo "$name_list_canonical" | denormalize_name | 
  sed -re 's/(.*)\t(.*)/s#^\2$#\1#g/g')"

echo "$name_list" | denormalize_name

echo

echo "$git_data" | cut -f 1 | sed -re "$cleaner_script" | sort | uniq -c | sort -k1n
