{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "js2-mode-0-20140114";

  src = fetchgit {
    url = "git://github.com/mooz/js2-mode.git";
    sha256 = "dbdc07b864a9506a21af445c7fb1c75fbffadaac980ee7bbf752470d8054bd65";
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
