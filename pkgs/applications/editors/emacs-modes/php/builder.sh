source $stdenv/setup

mkdir -p $out/share/emacs/site-lisp
cd $out/share/emacs/site-lisp
tar xvfz $src
mv php-mode-*/* .
rmdir php-mode-*
