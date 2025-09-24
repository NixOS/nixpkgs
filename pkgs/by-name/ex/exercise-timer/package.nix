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
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "mfep";
    repo = "exercise-timer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yparZ9XmHkjwvgpnERpi8hvRXdb8R+kAyFOFl+exXb4=";
    fetchLFS = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-JObzeiQHEGIDjOung3o8dpaXVcOoJS2v1hyrcS1fqcI=";
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
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "hiit";
    platforms = lib.platforms.linux;
  };
})
