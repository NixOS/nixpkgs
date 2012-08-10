{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "flymake-cursor-0.1.4";

  src = fetchurl {
    url = "http://www.emacswiki.org/emacs/download/flymake-cursor.el";
    sha256 = "1wxqqmn2fk2b778nksvgn1mi7ajarcpc5lla90xx9jwz47d9hx02";
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
    license = stdenv.lib.licences.publicDomain;

    platforms = stdenv.lib.platforms.all;
  };
}
