{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  vala,
  pkg-config,
  gnome,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  librsvg,
  gettext,
  itstool,
  libxml2,
  libgee,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-mines";
  version = "49.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${lib.versions.major finalAttrs.version}/gnome-mines-${finalAttrs.version}.tar.xz";
    hash = "sha256-iwygXAM7PCWZyZL4jr2UyysMjjiOoMAq5x2yb0P1bIQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
    librsvg
    libgee
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-mines";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-mines";
    description = "Clear hidden mines from a minefield";
    mainProgram = "gnome-mines";
    teams = [ teams.gnome ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
})
