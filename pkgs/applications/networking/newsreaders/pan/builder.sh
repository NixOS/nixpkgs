#! /bin/sh -e

buildInputs="$pkgconfig $gtk $gtkspell $gnet $libxml2 $perl $pcre"
. $stdenv/setup
genericBuild
