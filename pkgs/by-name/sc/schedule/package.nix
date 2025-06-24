{
  appstream-glib,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  gtk4,
  json-glib,
  lib,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "schedule";
  version = "0-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "zhrexl";
    repo = "ThisWeekInMyLife";
    rev = "f58f6db2eb0b4ddead4ac8db22babc0734b23a46";
    hash = "sha256-cFVPdF0jO0TRGCbidz/oxVAUGRISNcQE9LTcvM3W89o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream-glib
    desktop-file-utils
    gtk4
    json-glib
    libadwaita
    gettext
  ];

  meta = {
    description = "Kanban-styled planner that aims to help you organize your week";
    mainProgram = "thisweekinmylife";
    homepage = "https://github.com/zhrexl/ThisWeekInMyLife";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ FKouhai ];
  };
}
