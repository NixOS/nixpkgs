{ lib, stdenv
, fetchurl
, cmake
, ninja
, pkg-config
, intltool
, vala
, wrapGAppsHook3
, gcr
, libpeas
, gtk3
, webkitgtk
, sqlite
, gsettings-desktop-schemas
, libsoup
, glib-networking
, json-glib
, libarchive
}:

stdenv.mkDerivation rec {
  pname = "midori";
  version = "9.0";

  src = fetchurl {
    url = "https://github.com/midori-browser/core/releases/download/v${version}/midori-v${version}.tar.gz";
    sha256 = "05i04qa83dnarmgkx4xsk6fga5lw1lmslh4rb3vhyyy4ala562jy";
  };

  nativeBuildInputs = [
    cmake
    intltool
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    (libsoup.override { gnomeSupport = true; })
    gcr
    glib-networking
    gsettings-desktop-schemas
    gtk3
    libpeas
    sqlite
    webkitgtk
    json-glib
    libarchive
  ];

  passthru = {
    inherit gtk3;
  };

  meta = with lib; {
    description = "Lightweight WebKitGTK web browser";
    mainProgram = "midori";
    homepage = "https://www.midori-browser.org/";
    license = with licenses; [ lgpl21Plus ];
    platforms = with platforms; linux;
    maintainers = with maintainers; [ raskin ramkromberg ];
  };
}
