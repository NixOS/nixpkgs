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
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wwNOop2V84vZO3JV0+VZ+52cKPx8xJg2rLkjfgc/+n4=";
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
    mainProgram = "chess-clock";
    homepage = "https://gitlab.gnome.org/World/chess-clock";
    changelog = "https://gitlab.gnome.org/World/chess-clock/-/releases/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
}
