#! /bin/sh

export LD_LIBRARY_PATH=$glib/lib:$atk/lib:$pango/lib:$gtk/lib:$gnet/lib:$pspell/lib:$gtkspell/lib

ldd $pan/bin/pan

prog=$1
shift

$pan/bin/$prog $*
