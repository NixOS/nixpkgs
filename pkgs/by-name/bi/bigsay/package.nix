{
  lib,
  python3Packages,
  fetchFromGitHub,
  gtk4,
  gobject-introspection,
  pkg-config,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "bigsay";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sadneo";
    repo = "bigsay";
    rev = "v${version}";
    hash = "sha256-vRNIa9AnH/e7VxpHR1m2ono9F4Wev4uPd1HayYRj6XY=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    python3Packages.hatchling
  ];

  buildInputs = [
    gtk4
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  meta = with lib; {
    description = "GTK4 text display tool";
    license = licenses.mit;
    mainProgram = "bigsay";
  };
}
