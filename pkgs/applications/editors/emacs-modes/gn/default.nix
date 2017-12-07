{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "gn-mode-2017-09-21";
  src = fetchgit {
    url = "https://chromium.googlesource.com/chromium/src/tools/gn";
    rev = "34f2780efb3fe14fe361ec161ad58440de5a6b36";
    sha256 = "10cisqz3l6ny3471yi7y1z8v622lpl65zh0liqr6absvmy63g866";
  };
  buildInputs = [ emacs ];

  buildPhase = ''
    emacs --batch -f batch-byte-compile misc/emacs/gn-mode.el
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp misc/emacs/gn-mode.el* $out/share/emacs/site-lisp/
  '';
}
