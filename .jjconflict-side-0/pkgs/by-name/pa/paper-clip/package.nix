{
  lib,
  desktop-file-utils,
  exempi,
  fetchFromGitHub,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  poppler,
  stdenv,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paper-clip";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "Diego-Ivan";
    repo = "Paper-Clip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zJqN66WYYHLZCb6jnREnvhVonbQSucD7VG+JvpbmNMU=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    exempi
    glib
    gtk4
    libadwaita
    poppler
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/Diego-Ivan/Paper-Clip/releases/tag/v${finalAttrs.version}";
    description = "Edit PDF document metadata";
    homepage = "https://github.com/Diego-Ivan/Paper-Clip";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pdf-metadata-editor";
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
