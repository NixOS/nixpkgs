{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "js2-mode-0-20120712";

  src = fetchgit {
    url = "git://github.com/mooz/js2-mode.git";
    rev = "f8cb9c52614e0a8e477f1ac557585ed950246c9b";
    sha256 = "37055b7e8c1d9eee6b86f6b9b9d74ad196cc43701bc2263ffd539a3e44025047";
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
