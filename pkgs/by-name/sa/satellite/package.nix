{ lib
, python3
, fetchFromGitea
, gobject-introspection
, gtk3
, libhandy
, modemmanager
, wrapGAppsHook3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "satellite";
  version = "0.4.3";

  pyproject = true;

  src = fetchFromGitea {
    domain ="codeberg.org";
    owner = "tpikonen";
    repo = "satellite";
    rev = version;
    hash = "sha256-4L6zbHjWAIJJv2N3XKcfHSZUAUC2FPjK5hT9XGBtQ3w=";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3.pkgs.setuptools
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libhandy
    modemmanager
  ];

  propagatedBuildInputs = with python3.pkgs; [
    gpxpy
    pygobject3
    pynmea2
  ];

  strictDeps = true;

  meta = with lib; {
    description = "A program for showing navigation satellite data";
    longDescription = ''
      Satellite is an adaptive GTK3 / libhandy application which displays global navigation satellite system (GNSS: GPS et al.) data obtained from ModemManager or gnss-share.
      It can also save your position to a GPX-file.
    '';
    homepage = "https://codeberg.org/tpikonen/satellite";
    license = licenses.gpl3Only;
    mainProgram = "satellite";
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}
