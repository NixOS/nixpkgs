{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "lorem-ipsum-0.1";

  src = fetchurl {
    url = "http://www.emacswiki.org/emacs/download/lorem-ipsum.el";
    sha256 = "122d0z3xqfaikgk34l7bh989mfxddin2ljinysp2lqw8djfi7jsl";
  };

  phases = [ "buildPhase" "installPhase"];

  buildInputs = [ emacs ];

  buildPhase = ''
    cp $src lorem-ipsum.el
    emacs --batch -f batch-byte-compile lorem-ipsum.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install lorem-ipsum.el lorem-ipsum.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Insert dummy pseudo Latin text for Emacs";
    homepage = http://www.emacswiki.org/emacs/LoremIpsum;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
