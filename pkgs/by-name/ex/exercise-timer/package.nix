{
  lib,
  stdenv,
  alsa-lib,
  appstream-glib,
  cargo,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exercise-timer";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "mfep";
    repo = "exercise-timer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6MBSUYFZ8nMZX7acam8T0uJWb9E2/L9vnKzJq14p4BY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-fmY89VGv9tSMaILFnAVTAyp9PWGsvSCZ/9DfF5LI3xM=";
  };

  nativeBuildInputs = [
    appstream-glib
    cargo
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    libadwaita
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Timer app for high intensity interval training";
    homepage = "https://apps.gnome.org/Hiit/";
    changelog = "https://github.com/mfep/exercise-timer/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.gnome-circle.members;
    mainProgram = "hiit";
    platforms = lib.platforms.linux;
  };
})
