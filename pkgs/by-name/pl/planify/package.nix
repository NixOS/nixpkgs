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

stdenv.mkDerivation rec {
  pname = "planify";
<<<<<<< HEAD
  version = "4.17.0";
=======
  version = "4.16.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planify";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wsjLx5MYLAnYZEAeavvuh0nogpINeklo2VD3EftW+UA=";
=======
    hash = "sha256-jQW82nnIfuKhTWPlJQD2Mcl+Yl+NqnTbRnMn5+sfuD4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Task manager with Todoist support designed for GNU/Linux";
    homepage = "https://github.com/alainm23/planify";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Task manager with Todoist support designed for GNU/Linux";
    homepage = "https://github.com/alainm23/planify";
    license = licenses.gpl3Plus;
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "io.github.alainm23.planify";
  };
}
