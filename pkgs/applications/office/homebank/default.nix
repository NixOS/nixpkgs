{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor_icon_theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.1.3";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "0wzv2hkm30a1kqjldw02bzbh49bdmac041d6qybjzvkgwvrbmci2";
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
