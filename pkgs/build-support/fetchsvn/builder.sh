#! /bin/sh

buildinputs="$subversion"
. $stdenv/setup

echo "exporting $url (r$rev) into $out..."

svn export -r $rev "$url" $out || exit 1

echo $rev > $out/svn-revision || exit 1
