{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, vala
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
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    gtksourceview5
  ];

  postInstall = ''
    ln -s $out/bin/io.posidon.Paper $out/bin/paper
  '';

  meta = with lib; {
    description = "Take notes in Markdown";
    homepage = "https://posidon.io/paper/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ j0lol ];
  };
}
