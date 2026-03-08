{
  stdenv,
  lib,
  fetchFromGitHub,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  evolution-data-server-gtk4,
  glib,
  glib-networking,
  gst_all_1,
  gtk4,
  gtksourceview5,
  gxml,
  json-glib,
  libadwaita,
  libgee,
  libical,
  libportal-gtk4,
  libsecret,
  libsoup_3,
  libspelling,
  sqlite,
  webkitgtk_6_0,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "planify";
  version = "4.18.0";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9yNOiYmsYNLupIFn0H4rq9RqeCFzBpsE9Gj5kkqbNho=";
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
    evolution-data-server-gtk4
    glib
    glib-networking
    # Needed for GtkMediaStream creation with success.ogg, see #311295.
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk4
    gtksourceview5
    gxml
    json-glib
    libadwaita
    libgee
    libical
    libportal-gtk4
    libsecret
    libsoup_3
    libspelling
    sqlite
    webkitgtk_6_0
  ];

  meta = {
    description = "Task manager with Todoist support designed for GNU/Linux";
    homepage = "https://github.com/alainm23/planify";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    mainProgram = "io.github.alainm23.planify";
  };
})
