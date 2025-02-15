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
  version = "1.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/design";
    repo = "lorem";
    rev = finalAttrs.version;
    hash = "sha256-6+kDKKK1bkIOZlqzKWpzpjAS5o7bkbVFITMZVmJijuU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = finalAttrs.src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-l6vd521DmV019Yu5O1Kf5RKan2ROCBHlPiEDhf34Grc=";
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
    maintainers = lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux;
  };
})
