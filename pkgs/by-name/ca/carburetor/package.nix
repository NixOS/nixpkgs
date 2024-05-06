{
  lib,
  fetchzip,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook4,
  libadwaita,
  tractor,
}:

python3Packages.buildPythonApplication rec {

  pname = "carburetor";
  version = "4.5.1";

  pyproject = true;

  src = fetchzip {
    url = "https://framagit.org/tractor/carburetor/-/archive/${version}/carburetor-${version}.zip";
    hash = "sha256-FI5fTk1mQv5PvQd3Ygcug3Mm2yrk07s5BpiiDK8GA6A=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  dependencies = [
    python3Packages.setuptools
    python3Packages.pygobject3
    tractor
  ];

  meta = with lib; {
    homepage = "https://framagit.org/tractor/carburetor";
    description = "Graphical settings app for Tractor in GTK";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "tractor";
    maintainers = with maintainers; [ mksafavi ];
  };
}
