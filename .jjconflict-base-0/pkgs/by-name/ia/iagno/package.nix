{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils,
  glycin-loaders,
  gnome,
  gst_all_1,
  gtk4,
  itstool,
  libadwaita,
  libglycin-gtk4,
  libglycin,
  libxml2,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iagno";
  version = "50.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${lib.versions.major finalAttrs.version}/iagno-${finalAttrs.version}.tar.xz";
    hash = "sha256-/f1i0YdEGuofHWoOy71OJ3B/XI3cB5cUHKdQ3TBdyII=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    libxml2 # for xmllint
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glycin-loaders
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk4
    libadwaita
    libglycin
    libglycin-gtk4
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "iagno"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/iagno";
    description = "Computer version of the game Reversi, more popularly called Othello";
    mainProgram = "iagno";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
