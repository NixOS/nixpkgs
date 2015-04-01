{stdenv, fetchurl, ncurses, openssl, tcl, tk}:

stdenv.mkDerivation {
  name = "gtmess-0.97";

  src = fetchurl {
    url = mirror://sourceforge/gtmess/gtmess-0.97.tar.gz;
    sha256 = "1ipmqsrj0r1ssbgs2fpr4x5vnzlxlqhx9jrnadp1jw7s0sxpjqv0";
  };

  buildInputs = [ ncurses openssl tcl tk];

  meta = {
    description = "Console MSN Messenger client for Linux and other unix systems";
    homepage = http://gtmess.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
  };
}
