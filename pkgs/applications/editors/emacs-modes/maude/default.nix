{stdenv, fetchurl, emacs}:

stdenv.mkDerivation {
  name = "maude-mode-0.2";

  src = fetchurl {
    url = "mirror://sourceforge/maude-mode/maude-mode-0.2.tar.gz";
    sha256 = "19jdd7la0bxxxnnq4ryckf63jykg0r3v92z126x6djaigi3xn1yx";
  };

  buildInputs = [emacs];
  configureFlags = "--with-lispdir=$$out/share/emacs/site-lisp";

  meta = {
    description = "Emacs mode for the programming language Maude";
    license = "GPLv2";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
