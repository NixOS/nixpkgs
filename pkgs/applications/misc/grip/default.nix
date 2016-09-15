{ stdenv, fetchurl, gtk2, glib, pkgconfig, libgnome, libgnomeui, vte
, curl, cdparanoia, libid3tag, ncurses, libtool }:

stdenv.mkDerivation rec {
  name = "grip-3.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/grip/${name}.tar.gz";
    sha256 = "1zb6zpq7qmn6bflbgfwisyg3vrjr23yi1c1kqvwndl1f0shr8qyl";
  };

  buildInputs = [ gtk2 glib pkgconfig libgnome libgnomeui vte curl cdparanoia
    libid3tag ncurses libtool ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "GTK+-based audio CD player/ripper";
    homepage = "http://nostatic.org/grip";
    license = stdenv.lib.licenses.gpl2;

    maintainers = with stdenv.lib.maintainers; [ marcweber peti ];
    platforms = stdenv.lib.platforms.linux;
  };
}
