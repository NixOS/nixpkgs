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
    sha256 = "1vpxa2zjz3lkq9ldjg0fl65db9s6b4kcs8nyaqfz3jygma7ifg3w";
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
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
