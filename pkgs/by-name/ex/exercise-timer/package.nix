{
  lib,
  stdenv,
  alsa-lib,
  appstream-glib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitHub,
  json-glib,
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
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exercise-timer";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "mfep";
    repo = "exercise-timer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-81bGX5Oa5z5AbtYDzPcSyFsz0/zWcDw/Ky9n+EfnZNo=";
    fetchLFS = true;
  };

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    cargo
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustc
    wrapGAppsHook4
    vala
  ];

  buildInputs = [
    alsa-lib
    json-glib
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
