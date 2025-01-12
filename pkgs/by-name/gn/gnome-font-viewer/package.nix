{
  lib,
  stdenv,
  meson,
  ninja,
  gettext,
  fetchurl,
  pkg-config,
  gtk4,
  glib,
  libxml2,
  libadwaita,
  fribidi,
  wrapGAppsHook4,
  gnome,
  harfbuzz,
}:

stdenv.mkDerivation rec {
  pname = "gnome-font-viewer";
  version = "47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/${lib.versions.major version}/gnome-font-viewer-${version}.tar.xz";
    hash = "sha256-uOWgQuCyQbDHyuQ/dNoNX4jmQjAXqR/rhudhfttAgO0=";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook4
    libxml2
    glib
  ];

  buildInputs = [
    gtk4
    glib
    harfbuzz
    libadwaita
    fribidi
  ];

  # Do not run meson-postinstall.sh
  preConfigure = "sed -i '2,$ d'  meson-postinstall.sh";

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-font-viewer";
    };
  };

  meta = with lib; {
    description = "Program that can preview fonts and create thumbnails for fonts";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-font-viewer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
