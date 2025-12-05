{
  lib,
  stdenv,
  fetchFromGitLab,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  openssl,
  pango,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "impression";
  version = "3.5.4";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Impression";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jOQ3WLsbL/ODTfTPjb8wbd2QDER2ubtan2jL0nw/rk4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-uUW8xeqQCav7YP/FScySZ2z9jWatkgKw8bPpwX0TOVw=";
  };

  nativeBuildInputs = [
    blueprint-compiler
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
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Straight-forward and modern application to create bootable drives";
    homepage = "https://gitlab.com/adhami3310/Impression";
    changelog = "https://gitlab.com/adhami3310/Impression/-/releases/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "impression";
    maintainers = with lib.maintainers; [ dotlambda ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
