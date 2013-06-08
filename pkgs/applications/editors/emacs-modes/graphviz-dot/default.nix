{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "graphviz-dot-mode-0.3.3";

  src = fetchurl {
    url = "http://www.graphviz.org/Misc/graphviz-dot-mode.el";
    sha256 = "6465c18cfaa519a063cf664207613f70b0a17ac5eabcfaa949b3c4c289842953";
  };

  buildInputs = [ emacs ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp -v ${src} "$out/share/emacs/site-lisp/graphviz-dot-mode.el"
    emacs -batch --eval '(setq load-path (cons "." load-path))' -f batch-byte-compile "$out/share/emacs/site-lisp/graphviz-dot-mode.el"
  '';

  meta = {
    homepage = "http://www.graphviz.org/";
    description = "An emacs mode for the DOT Language, used by graphviz";
  };
}
