#!/usr/bin/env bash
#
# Make addons subdirectory and install all addons
# and generate a jaddons.nix file for nixpkgs

cd `dirname "$(realpath $0)"`

git clone https://github.com/jsoftware/addonrepos/ addonrepos
cd addonrepos

# protocol
# P=https|git
# use git instead of https if you have write access to the repos

mkdir addons
cd addons

P=git
JADDONS=jaddons.nix
echo "" > $JADDONS

git init .

f() {
 p=`sed "s/github:/github.com\//" <<<"$1"`
 d=`sed "s/_/\//" <<<"${1##*/}"`
 git submodule add $P://$p $d

 pushd "$d"
 c=`git log -1 | head -n 1 | sed -e 's/commit //'`
 popd

 tarball=`echo "https://$p/archive/$c.tar.gz"`
 h=`nix-prefetch-url --unpack $tarball`
 o=`sed 's/github:\(.*\)\/\(.*\)/\1/' <<<"$1"`
 r=`sed 's/github:\(.*\)\/\(.*\)/\2/' <<<"$1"`

 echo "$r = buildJAddonGitHub {" >> $JADDONS
 echo "  name = \"$r\";"         >> $JADDONS
 echo "  owner = \"$o\";"        >> $JADDONS
 echo "  rev = \"$c\";"          >> $JADDONS
 echo "  sha256 = \"$h\";"       >> $JADDONS
 echo "};"                       >> $JADDONS
}

cat ../repos.txt | while read p; do
 f $p
done

cp "addons/$JADDONS" .
