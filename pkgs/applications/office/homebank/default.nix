{ fetchurl, lib, stdenv, gtk, pkg-config, libofx, intltool, wrapGAppsHook
, libsoup_3, gnome }:

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.7.1";
  src = fetchurl {
    url = "http://homebank.free.fr/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-fwqSnXde7yalqfKfo8AT8+762/aYLMCGp8dd3bm09Ck=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [ gtk libofx libsoup_3 gnome.adwaita-icon-theme];

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    homepage = "http://homebank.free.fr/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
