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

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # Use absolute path for libshew installation to make our patched gobject-introspection
    # aware of the location to hardcode in the generated GIR file.
    ./shew-gir-path.patch
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "gjs = find_program('gjs')" "gjs = find_program('${lib.getExe gjs}')"
  '';

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

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-extensions-app"; };
  };

  meta = {
    description = "Small app for managing GNOME Shell extensions";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-extensions-app";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-extensions-app/-/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
    mainProgram = "gnome-extensions-app";
  };
})
