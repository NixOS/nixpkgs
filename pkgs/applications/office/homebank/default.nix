{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor-icon-theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.1.7";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "19szz86jxya8v4r3pa5czng9q2kn5hhbk273x1wqvdv40z0577jp";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libofx intltool hicolor-icon-theme libsoup
    gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric pSub ];
    platforms = platforms.linux;
  };
}
