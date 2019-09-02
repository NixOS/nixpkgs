{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor-icon-theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.2.3";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "1wdg86gwd0rc9m3mni9qlh746kxmjn4mk5q7fplxrcp2ajdcqr3a";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libofx intltool hicolor-icon-theme libsoup
    gnome3.adwaita-icon-theme ];

  meta = with stdenv.lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
