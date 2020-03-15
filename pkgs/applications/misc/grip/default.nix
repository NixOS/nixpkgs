{ stdenv, fetchurl, gtk2, glib, pkgconfig, libgnome, libgnomeui, vte
, curl, cdparanoia, libid3tag, ncurses, libtool }:

stdenv.mkDerivation rec {
  name = "grip-4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/grip/${name}.tar.gz";
    sha256 = "0iy7bcyrxm7zyrxah06qyxdshkgq6yqkadlw211j2qzld38a79j5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 glib libgnome libgnomeui vte curl cdparanoia
    libid3tag ncurses libtool ];

  hardeningDisable = [ "format" ];

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  meta = {
    description = "GTK-based audio CD player/ripper";
    homepage = http://nostatic.org/grip;
    license = stdenv.lib.licenses.gpl2;

    maintainers = with stdenv.lib.maintainers; [ marcweber peti ];
    platforms = stdenv.lib.platforms.linux;
  };
}
