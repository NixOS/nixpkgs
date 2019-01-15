{ stdenv, fetchurl
, autoreconfHook, pkgconfig, wrapGAppsHook
, glib, intltool, gtk3, gtksourceview, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "xpad-${version}";
  version = "5.3.0";

  src = fetchurl {
    url = "https://launchpad.net/xpad/trunk/${version}/+download/xpad-${version}.tar.bz2";
    sha256 = "0gv9indihr2kbv9iqdqq4mfj6l6qgzwc06jm08gmg10f262sni34";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig wrapGAppsHook ];

  buildInputs = [ glib intltool gtk3 gtksourceview hicolor-icon-theme ];

  meta = with stdenv.lib; {
    description = "A sticky note application for jotting down things to remember";
    homepage = https://launchpad.net/xpad;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
  };
}
