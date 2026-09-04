{
  desktop-file-utils,
  fetchurl,
  gjs,
  glib,
  gnome,
  gobject-introspection,
  gtk4,
  lib,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-extensions-app";
  version = "51.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-extensions-app/${lib.versions.major finalAttrs.version}/gnome-extensions-app-${finalAttrs.version}.tar.xz";
    hash = "sha256-xgmY+rH2fnP86+qkDFgG3B6//W4esW47dHLcQmkcheY=";
  };

  patches = [
    # Use absolute path for libshew installation to make our patched gobject-introspection
    # aware of the location to hardcode in the generated GIR file.
    ./shew-gir-path.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    gtk4
    libadwaita
  ];

  mesonFlags = [ ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-extensions-app"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-extensions-app";
    description = "GNOME Extensions is a small app for managing GNOME Shell extensions";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gnome-extensions-app";
  };
})
