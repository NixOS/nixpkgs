{ stdenv, fetchurl, gtk2, glib, pkgconfig, libgnome, libgnomeui, vte
, curl, cdparanoia, libid3tag, ncurses, libtool }:

stdenv.mkDerivation rec {
  name = "grip-3.10.2";

  src = fetchurl {
    url = "mirror://sourceforge/grip/${name}.tar.gz";
    sha256 = "1wngrvw0zkrd2xw7c6w0qmq38jxishp5q9xvm6qlycza2czb4p36";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 glib libgnome libgnomeui vte curl cdparanoia
    libid3tag ncurses libtool ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "GTK-based audio CD player/ripper";
    homepage = http://nostatic.org/grip;
    license = stdenv.lib.licenses.gpl2;

    maintainers = with stdenv.lib.maintainers; [ marcweber peti ];
    platforms = stdenv.lib.platforms.linux;
  };
}
