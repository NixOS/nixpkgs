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
  pname = "grip";
  version = "4.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/grip/grip-${version}.tar.gz";
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

    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.linux;
  };
}
