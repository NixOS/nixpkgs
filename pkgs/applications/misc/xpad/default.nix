{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  wrapGAppsHook3,
  glib,
  intltool,
  gtk3,
  gtksourceview,
}:

stdenv.mkDerivation rec {
  pname = "xpad";
  version = "5.4.0";

  src = fetchurl {
    url = "https://launchpad.net/xpad/trunk/${version}/+download/xpad-${version}.tar.bz2";
    sha256 = "1qpmlwn0bcw1q73ag0l0fdnlzmwawfvsy4g9y5b0vyrc58lcp5d3";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
    intltool
  ];

  buildInputs = [
    glib
    gtk3
    gtksourceview
  ];

  meta = with lib; {
    description = "A sticky note application for jotting down things to remember";
    mainProgram = "xpad";
    homepage = "https://launchpad.net/xpad";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
  };
}
