. $stdenv/setup

mkdir -p $out/emacs/site-lisp
tar zxvf $src
cp haskell-mode*/*.el $out/emacs/site-lisp
cp haskell-mode*/*.hs $out/emacs/site-lisp
