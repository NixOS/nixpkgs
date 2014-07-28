{stdenv, fetchurl, ncurses, openssl, tcl, tk}:

stdenv.mkDerivation {
  name = "gtmess-0.96";

  src = fetchurl {
    url = mirror://sourceforge/gtmess/gtmess-0.96.tar.gz;
    sha256 = "0w29wyshx32485c7wazj51lvk2j9k1kn2jmwpf916r4513hwplvm";
  };

  buildInputs = [ ncurses openssl tcl tk];

  patches = [ ./va_list.patch ];

  meta = {
    description = "Console MSN Messenger client for Linux and other unix systems";
    homepage = http://gtmess.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
  };
}
