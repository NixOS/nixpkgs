{ lib
, desktop-file-utils
, fetchFromGitLab
, gobject-introspection
, gsound
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "chess-clock";
  version = "0.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XDOCHFZC3s3b/4kD1ZkhWar3kozW3vXc0pk7O6oQfiE=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gsound
    gtk4
    libadwaita
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
  ];

  meta = with lib; {
    description = "Time games of over-the-board chess";
    homepage = "https://gitlab.gnome.org/World/chess-clock";
    license = licenses.gpl3Plus;
    mainProgram = "chess-clock";
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
}
