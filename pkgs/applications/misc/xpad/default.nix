{ stdenv, fetchurl
, autoreconfHook, pkgconfig, wrapGAppsHook
, glib, intltool, gtk3, gtksourceview, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "xpad-${version}";
  version = "5.4.0";

  src = fetchurl {
    url = "https://launchpad.net/xpad/trunk/${version}/+download/xpad-${version}.tar.bz2";
    sha256 = "1qpmlwn0bcw1q73ag0l0fdnlzmwawfvsy4g9y5b0vyrc58lcp5d3";
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
