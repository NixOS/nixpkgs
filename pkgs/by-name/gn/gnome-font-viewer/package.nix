{ lib
, stdenv
, fetchpatch2
, meson
, ninja
, gettext
, fetchurl
, pkg-config
, gtk4
, glib
, libxml2
, gnome-desktop
, libadwaita
, fribidi
, wrapGAppsHook4
, gnome
, harfbuzz
}:

stdenv.mkDerivation rec {
  pname = "gnome-font-viewer";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/${lib.versions.major version}/gnome-font-viewer-${version}.tar.xz";
    hash = "sha256-WS9AHkhdAswETUh7tcjgTJYdpoViFnaKWfH/mL0tU3w=";
  };

  patches = lib.optionals stdenv.cc.isClang [
    # Fixes an incompatible function pointer error when building with clang 16
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gnome-font-viewer/-/commit/565d795731471c27542bb9ee60820a2d0d15534e.diff";
      hash = "sha256-8dgOVTx6ZbvXROlIWTZU2xNWJ11LlJykRs699cgZqow=";
    })
  ];

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
    gnome-desktop
    harfbuzz
    libadwaita
    fribidi
  ];

  # Do not run meson-postinstall.sh
  preConfigure = "sed -i '2,$ d'  meson-postinstall.sh";

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
