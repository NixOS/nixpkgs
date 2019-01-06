{ stdenv, fetchurl, cmake, ninja, pkgconfig, intltool, vala, wrapGAppsHook, gcr
, gtk3, webkitgtk, sqlite, gsettings-desktop-schemas, libsoup, glib-networking, gnome3
}:

stdenv.mkDerivation rec {
  pname = "midori";
  version = "7";

  src = fetchurl {
    url = "https://github.com/midori-browser/core/releases/download/v${version}/midori-v${version}.0.tar.gz";
    sha256 = "0ffdnjp55s0ci737vlhxikb2nihghwlb6mjcjzpgpnzi47vjqnwh";
  };

  nativeBuildInputs = [
    pkgconfig cmake ninja intltool vala wrapGAppsHook
  ];

  buildInputs = [
    gtk3 webkitgtk sqlite gsettings-desktop-schemas gcr
    (libsoup.override { gnomeSupport = true; }) gnome3.libpeas
    glib-networking
  ];

  meta = with stdenv.lib; {
    description = "Lightweight WebKitGTK+ web browser";
    homepage = https://www.midori-browser.org/;
    license = with licenses; [ lgpl21Plus ];
    platforms = with platforms; linux;
    maintainers = with maintainers; [ raskin ramkromberg ];
  };
}
