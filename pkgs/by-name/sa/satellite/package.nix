{
  lib,
  python3,
  fetchFromGitea,
  gobject-introspection,
  libadwaita,
  modemmanager,
  wrapGAppsHook4,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "satellite";
  version = "0.9.0";

  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "tpikonen";
    repo = "satellite";
    tag = version;
    hash = "sha256-w0ZpH1joFoV7W7PH74//LGLUJQLCpAGcC6GlyTbdsTE=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  build-system = with python3.pkgs; [ setuptools ];

  buildInputs = [
    libadwaita
    modemmanager
  ];

  dependencies = with python3.pkgs; [
    gpxpy
    pygobject3
    pynmea2
  ];

  strictDeps = true;

  meta = {
    description = "Program for showing navigation satellite data";
    longDescription = ''
      Satellite is an adaptive GTK3 / libhandy application which displays global navigation satellite system (GNSS: GPS et al.) data obtained from ModemManager or gnss-share.
      It can also save your position to a GPX-file.
    '';
    homepage = "https://codeberg.org/tpikonen/satellite";
    license = lib.licenses.gpl3Only;
    mainProgram = "satellite";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
