. $stdenv/setup || exit 1

mkdir -p $out/emacs/site-lisp || exit 1
cd $out/emacs/site-lisp || exit 1
tar xvfz $src || exit 1
mv nxml-mode-*/* . || exit 1
rmdir nxml-mode-*

exit 0
