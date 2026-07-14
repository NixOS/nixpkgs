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
  version = "1.6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "lorem";
    rev = finalAttrs.version;
    hash = "sha256-DY2UVB6N3vQehDm1s3KIjodUfyWu3QBo6NxWlPswDN4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-DE0jzI9Tmusm6VT19PsmJoTYHQ4fjrg3ik6tAWhMVSA=";
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
