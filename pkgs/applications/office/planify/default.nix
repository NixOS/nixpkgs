{ stdenv
, lib
, fetchFromGitHub
, desktop-file-utils
, meson
, ninja
, pkg-config
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
, libportal-gtk4
, pantheon
, sqlite
, webkitgtk_6_0
}:

stdenv.mkDerivation rec {
  pname = "planify";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planify";
    rev = version;
    sha256 = "sha256-H8TPuqKRwbcB+2NTC5ZIK7y6uiYbTT4svtx21FbTzME=";
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
    evolution-data-server
    glib
    glib-networking
    gtk4
    json-glib
    libadwaita
    libgee
    libical
    libportal-gtk4
    pantheon.granite7
    sqlite
    webkitgtk_6_0
  ];

  meta = with lib; {
    description = "Task manager with Todoist support designed for GNU/Linux";
    homepage = "https://github.com/alainm23/planify";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.github.alainm23.planify";
  };
}
