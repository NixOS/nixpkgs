{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  itstool,
  desktop-file-utils,
  gnome,
  glib,
  gtk3,
  libexif,
  libtiff,
  colord,
  colord-gtk,
  libcanberra-gtk3,
  lcms2,
  vte,
  exiv2,
}:

stdenv.mkDerivation rec {
  pname = "gnome-color-manager";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-color-manager/${lib.versions.majorMinor version}/gnome-color-manager-${version}.tar.xz";
    hash = "sha256-fDwXj6rPy/EdVt4izSZZRqfViqEOPNlowpOOL79Q/e4=";
  };

  patches = [ ./0001-Fix-build-with-Exiv2-0.28.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glib
    itstool
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    libexif
    libtiff
    colord
    colord-gtk
    libcanberra-gtk3
    lcms2
    vte
    exiv2
  ];

  strictDeps = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-color-manager";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "Set of graphical utilities for color management to be used in the GNOME desktop";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
}
