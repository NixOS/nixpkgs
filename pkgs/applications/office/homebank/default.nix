{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook
, libsoup, gnome }:

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.7";
  src = fetchurl {
    url = "http://homebank.free.fr/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-xDiVzDeeA+KuLESj911LBq8hgDlltrxSA051xUOD2Ro=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [ gtk libofx libsoup gnome.adwaita-icon-theme];

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = "http://homebank.free.fr/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
