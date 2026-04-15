{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk4,
  libgee,
  libadwaita,
  gtksourceview5,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  template-glib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elastic";
  version = "1.0.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "elastic";
    rev = finalAttrs.version;
    hash = "sha256-zOqOAUbPjyVl/96oVBhsjBrSMGt+NEbraznNGu374dM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    gtksourceview5
    template-glib
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Design spring animations";
    homepage = "https://gitlab.gnome.org/World/elastic/";
    changelog = "https://gitlab.gnome.org/World/elastic/-/releases/${finalAttrs.version}";
    mainProgram = "app.drey.Elastic";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ _0xMRTT ];
    teams = [ lib.teams.gnome-circle ];
  };
})
