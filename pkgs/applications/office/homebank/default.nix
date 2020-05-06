{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.4.1";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "1m1hpaby6zi8y0vmj2ljklp34a55l2qsr7pxw3852k2m4v5n9zsx";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libofx intltool libsoup
    gnome3.adwaita-icon-theme ];

  meta = with stdenv.lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = "http://homebank.free.fr/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
