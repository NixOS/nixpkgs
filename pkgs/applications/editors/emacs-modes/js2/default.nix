{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "js2-mode-0-20120601";

  src = fetchgit {
    url = "git://github.com/mooz/js2-mode.git";
    rev = "81bcbf7df7077db27facf0470cf9e31c18b8333e";
    sha256 = "1bec62816ec9d5f5882832902020573d95d038fff25b17bf1975b84a3ab535c3";
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
