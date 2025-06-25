{
  lib,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lorem";
  version = "1.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/design";
    repo = "lorem";
    rev = finalAttrs.version;
    hash = "sha256-q6gpxxNebf2G/lT5wWXT/lVp3zR8QLWB8/sdK+wLTJ8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-4JYYcfsEoCGJWZCp0273gXrf8hfuHL/QSsLEHvNa4uA=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://gitlab.gnome.org/World/design/lorem/-/releases/${finalAttrs.version}";
    description = "Generate placeholder text";
    homepage = "https://apps.gnome.org/Lorem/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "lorem";
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
