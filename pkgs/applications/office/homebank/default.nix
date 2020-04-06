{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.3.2";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "1fr4060yqlciay98dypvifmfvr8y2kbpj89d86mcvq9gb00vij2b";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk libofx intltool libsoup
    gnome3.adwaita-icon-theme ];

  meta = with stdenv.lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
