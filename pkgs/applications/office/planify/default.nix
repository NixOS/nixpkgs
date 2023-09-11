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
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planify";
    # The commit is named as "Release 4.1.1", published to Flathub, but not tags
    # https://github.com/flathub/io.github.alainm23.planify/commit/2a353ccfcf3379add6778d569f49da37f40accfa
    # https://github.com/alainm23/planify/issues/1002
    rev = "adf3629bcacfc9978f6dde5b87eff0278533ab3e";
    hash = "sha256-xqklvSYmqBQ+IQ3lRjMbV4W4vD/rLCln7rBVCbYiBGo=";
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
