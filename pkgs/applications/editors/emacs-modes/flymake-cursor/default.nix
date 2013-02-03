{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "flymake-cursor-0.1.5";

  src = fetchurl {
    url = "http://www.emacswiki.org/emacs/download/flymake-cursor.el";
    sha256 = "1qqppd1786w8pl1avjb01n23lwihb7m0hr23abjklsxz03gmp4qz";
  };

  phases = [ "buildPhase" "installPhase"];

  buildInputs = [ emacs ];

  buildPhase = ''
    cp $src flymake-cursor.el
    emacs --batch -f batch-byte-compile flymake-cursor.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install flymake-cursor.el flymake-cursor.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Displays flymake error msg in minibuffer after delay.";
    homepage = http://www.emacswiki.org/emacs/flymake-cursor.el;
    license = stdenv.lib.licenses.publicDomain;

    platforms = stdenv.lib.platforms.all;
  };
}
