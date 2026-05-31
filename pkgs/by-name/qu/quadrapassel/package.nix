{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gtk4,
  libadwaita,
  pango,
  gnome,
  gdk-pixbuf,
  librsvg,
  libmanette,
  blueprint-compiler,
  wrapGAppsHook4,
  meson,
  ninja,
  vala,
  desktop-file-utils,
  libsndfile,
  openal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quadrapassel";
  version = "50.1";

  src = fetchurl {
    url = "mirror://gnome/sources/quadrapassel/${lib.versions.major finalAttrs.version}/quadrapassel-${finalAttrs.version}.tar.xz";
    hash = "sha256-UeQ9BZ8GuJwQXVPXHe8L2XzpREcO4Tn8fnQ/zkpsOZQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    desktop-file-utils
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    pango
    gdk-pixbuf
    librsvg
    libmanette
    # for libgnome-games-support + sound feature
    libsndfile
    openal
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "quadrapassel";
    };
  };

  meta = {
    description = "Classic falling-block game, Tetris";
    mainProgram = "quadrapassel";
    homepage = "https://gitlab.gnome.org/GNOME/quadrapassel";
    changelog = "https://gitlab.gnome.org/GNOME/quadrapassel/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
