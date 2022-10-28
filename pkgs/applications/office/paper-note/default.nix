{ lib
, stdenv
, fetchFromGitLab
, vala
, meson
, ninja
, pkg-config
, glib
, gtk4
, dbus
, libgee
, librsvg
, libadwaita
, gtksourceview5
, blueprint-compiler
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "paper-note";
  version = "22.11";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = "paper";
    rev = version;
    hash = "sha256-o5MYagflHE8Aup8CbqauRBrdt3TrSlffs35psYT7hyE=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    dbus
    libgee
    librsvg
    libadwaita
    gtksourceview5
  ];

  meta = with lib; {
    description = "A pretty markdown note-taking app for Gnome";
    homepage = "https://posidon.io/paper";
    mainProgram = "io.posidon.Paper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
