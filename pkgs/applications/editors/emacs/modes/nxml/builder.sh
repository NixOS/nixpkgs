. $stdenv/setup

mkdir -p $out/emacs/site-lisp
cd $out/emacs/site-lisp
tar xvfz $src
mv nxml-mode-*/* .
rmdir nxml-mode-*
