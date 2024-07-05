if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup
echo "getting $url${rev:+ ($rev)} into $out"

hg clone --insecure "$url" hg-clone

hg archive -q$subrepoClause -y ${rev:+-r "$rev"} --cwd hg-clone $out
rm -f $out/.hg_archival.txt
