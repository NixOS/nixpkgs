{ lib, stdenv, fetchurl, gtk2, glib, pkg-config, libgnome, libgnomeui, vte
, curl, cdparanoia, libid3tag, ncurses, libtool }:

stdenv.mkDerivation rec {
  name = "grip-4.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/grip/${name}.tar.gz";
    sha256 = "1si5kidwg0i2jg0brzyvjrzw24v3km2hdgd4kda1adzq81a3p1cs";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 glib libgnome libgnomeui vte curl cdparanoia
    libid3tag ncurses libtool ];

  hardeningDisable = [ "format" ];

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  meta = {
    description = "GTK-based audio CD player/ripper";
    homepage = "http://nostatic.org/grip";
    license = lib.licenses.gpl2;

    maintainers = with lib.maintainers; [ marcweber peti ];
    platforms = lib.platforms.linux;
  };
}
