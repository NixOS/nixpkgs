{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, hicolor-icon-theme, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.2.6";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "10cqii1bsc7dmg8nzj6xhmk44r390vca49vbsw4g504h0bvwn54s";
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
