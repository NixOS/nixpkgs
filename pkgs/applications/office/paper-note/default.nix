{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, cmake
, pkg-config
, python3
, vala
, glib
, gtk3
, gtk4
, libgee
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
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    cmake
    glib
    python3
    gtk3
    gtk4
    libadwaita
    libgee
    gtksourceview5
    blueprint-compiler
  ];

  postInstall = ''
    ln -s $out/bin/io.posidon.paper $out/bin/paper
  '';

  meta = with lib; {
    description = "Take notes in Markdown";
    homepage = "https://posidon.io/paper/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ j0lol ];
  };
}