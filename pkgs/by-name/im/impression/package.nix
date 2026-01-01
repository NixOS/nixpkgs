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
<<<<<<< HEAD
  version = "3.5.5";
=======
  version = "3.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Impression";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ldWINEU4ne15neinuPhs90X2bTkg44xcalyEW0g6TdA=";
=======
    hash = "sha256-jOQ3WLsbL/ODTfTPjb8wbd2QDER2ubtan2jL0nw/rk4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
<<<<<<< HEAD
    hash = "sha256-QjGtPA2RO+0BF/bTlBz8xx8DRO9lRwTOQIgRmZB6Fbs=";
=======
    hash = "sha256-uUW8xeqQCav7YP/FScySZ2z9jWatkgKw8bPpwX0TOVw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
