{ stdenv
, lib
, fetchFromGitHub
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook4
, evolution-data-server
, glib
, glib-networking
, gtk4
, json-glib
, libadwaita
, libgee
, libical
, pantheon
, sqlite
, webkitgtk_6_0
}:

stdenv.mkDerivation rec {
  pname = "planify";
  version = "unstable-2023-04-20";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planify";
    rev = "97c0f1c30d087e2ac459241bfdb9b606a12a77ce";
    sha256 = "sha256-W4Hfa9zgKpGKfd7QSTLF2FT0vSJ5mQMV+W9WWltZlL4=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    evolution-data-server
    glib
    glib-networking
    gtk4
    json-glib
    libadwaita
    libgee
    libical
    pantheon.granite7
    sqlite
    webkitgtk_6_0
  ];

  mesonFlags = [
    "-Dproduction=true"
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
    substituteInPlace build-aux/meson/post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  meta = with lib; {
    description = "Task manager with Todoist support designed for GNU/Linux";
    homepage = "https://github.com/alainm23/planify";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.alainm23.task-planner";
  };
}
