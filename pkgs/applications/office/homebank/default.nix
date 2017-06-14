{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor_icon_theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.1.5";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "03rkl4bvi1cmb8rqyvmhxhg63bdmb3nzqa3firfimsbphm3x6gsw";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libofx intltool hicolor_icon_theme libsoup
    gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric pSub ];
    platforms = platforms.linux;
  };
}
