{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gnome,
  gtk3,
  glib,
  gobject-introspection,
  libarchive,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-autoar";
  version = "0.4.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-autoar/${lib.versions.majorMinor finalAttrs.version}/gnome-autoar-${finalAttrs.version}.tar.xz";
    hash = "sha256-g4xTBvw4v6ovI6viQmL0vxV3HjMD+13LdPW5x6YV2r4=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    libarchive
    glib
  ];

  mesonFlags = [
    "-Dvapi=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-autoar";
    };
  };

  meta = {
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gnome ];
    license = lib.licenses.lgpl21Plus;
    description = "Library to integrate compressed files management with GNOME";
  };
})
