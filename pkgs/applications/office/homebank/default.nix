{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook
, libsoup, gnome }:

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.6.6";
  src = fetchurl {
    url = "http://homebank.free.fr/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-ZW/N8YUU8r7SYY/+hqVYrqYW/KQqtuChfQJxXftl3A4=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [ gtk libofx libsoup gnome.adwaita-icon-theme];

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = "http://homebank.free.fr/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
