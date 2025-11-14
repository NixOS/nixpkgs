{
  lib,
  stdenv,
  rustPlatform,
  gettext,
  meson,
  ninja,
  fetchurl,
  pkg-config,
  gtk4,
  glib,
  desktop-file-utils,
  appstream-glib,
  wrapGAppsHook4,
  python3,
  gnome,
  libadwaita,
  librsvg,
  rustc,
  cargo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-tour";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tour/${lib.versions.major finalAttrs.version}/gnome-tour-${finalAttrs.version}.tar.xz";
    hash = "sha256-LX2KKgzRF4BjpBTaWAk9JsD7GndgjYrX+9eRGl1iZNM=";
  };

  cargoVendorDir = "vendor";

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    appstream-glib
    cargo
    desktop-file-utils
    gettext
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-tour";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tour";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-tour/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "GNOME Greeter & Tour";
    mainProgram = "gnome-tour";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
