{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "js2-mode-0-20120130";

  src = fetchgit {
    url = "git://github.com/mooz/js2-mode.git";
    rev = "4c008b1987aa53769899e24808b6d74b41b4ff40";
    sha256 = "6af5f52e46ffe85b7610e2db19a96afbef60a6f5374f1c5db3653448e30160be";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs --batch -f batch-byte-compile js2-mode.el
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp js2-mode.el js2-mode.elc $out/share/emacs/site-lisp/
  '';
}
