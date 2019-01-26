{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor-icon-theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.2.2";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "19cm49p2x6nwia2yvwj3fv7jxbhw0vx4bs1zqbfvdr5vzwgj5j5c";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libofx intltool hicolor-icon-theme libsoup
    gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
