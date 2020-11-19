{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool, wrapGAppsHook
, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "homebank-5.4.3";
  src = fetchurl {
    url = "http://homebank.free.fr/public/${name}.tar.gz";
    sha256 = "02wd569viwy6ncy0144z9nxr3zmpl4shkqhz7zzwyky4gknxf8lj";
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
