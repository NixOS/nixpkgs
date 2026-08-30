{
  lib,
  stdenv,
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  gst_all_1,
  gtk4,
  json-glib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  vala,
  wrapGAppsHook4,
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
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    vala
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
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
