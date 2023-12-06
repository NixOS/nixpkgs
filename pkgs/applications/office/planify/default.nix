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
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planify";
    # The commit is named as "Release 4.1.4", published to Flathub, but not tags
    # https://github.com/flathub/io.github.alainm23.planify/commit/f345f81b55e4638bc6605e0bf9d15a057b846252
    # https://github.com/alainm23/planify/issues/1002
    rev = "73fd6cb7acfc60937d1403238c255736b97aa94b";
    hash = "sha256-K3QFFpq2MJxK34Uh0qFyaSGeTPTZbwIVYkosFUrhflQ=";
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
