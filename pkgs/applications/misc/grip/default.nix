{ lib
, stdenv
, fetchurl
, gtk2
, glib
, pkg-config
, libgnome
, libgnomeui
, vte
, curl
, cdparanoia
, libid3tag
, ncurses
, libtool
}:

stdenv.mkDerivation rec {
  name = "grip-4.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/grip/${name}.tar.gz";
    sha256 = "sha256-nXtGgJeNYM8lyllNi9UdmsnVcHOCXfryWmKGZ9QFTHE=";
  };

  nativeBuildInputs = [ pkg-config libtool ];
  buildInputs = [
    gtk2
    glib
    libgnome
    libgnomeui
    vte
    curl
    cdparanoia
    libid3tag
    ncurses
  ];
  enableParallelBuilding = true;

  meta = {
    description = "GTK-based audio CD player/ripper";
    homepage = "http://nostatic.org/grip";
    license = lib.licenses.gpl2Plus;

    maintainers = with lib.maintainers; [ marcweber peti ];
    platforms = lib.platforms.linux;
  };
}
