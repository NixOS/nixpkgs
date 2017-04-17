{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor_icon_theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.1.4";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "07zxb9n7d281nfv29gi09fsp7y73fx4w2s48hgdn9s4vij25zwqa";
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
