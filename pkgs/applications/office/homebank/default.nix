{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook
, libsoup, gnome }:

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.6.3";
  src = fetchurl {
    url = "http://homebank.free.fr/public/sources/homebank-${version}.tar.gz";
    sha256 = "419475f564bbd9be7f4101b1197ce53ea21e8374bcf0505391406317ed823828";
  };
  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [ gtk libofx libsoup gnome.adwaita-icon-theme ];

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = "http://homebank.free.fr/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
