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

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-color-manager";
  version = "3.36.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-color-manager/${lib.versions.majorMinor finalAttrs.version}/gnome-color-manager-${finalAttrs.version}.tar.xz";
    hash = "sha256-OQTUKrtOpWbfC4gOgr8Ln4Y4bGkvFbMYRppMe+M6iH8=";
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
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Set of graphical utilities for color management to be used in the GNOME desktop";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
