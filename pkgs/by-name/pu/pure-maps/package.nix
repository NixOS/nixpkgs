{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  nemo-qml-plugin-dbus,
  s2geometry,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "pure-maps";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "pure-maps";
    rev = version;
    hash = "sha256-UkPZ5Wy/05srZv1r5GLoT5hFQVLfYF6Q2rQDFoILlQ0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    python3
    libsForQt5.qttools
    python3.pkgs.wrapPython
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtquickcontrols2
    libsForQt5.qtlocation
    libsForQt5.qtsensors
    nemo-qml-plugin-dbus
    libsForQt5.pyotherside
    libsForQt5.mapbox-gl-qml
    s2geometry
  ];

  cmakeFlags = [ "-DFLAVOR=qtcontrols" ];

  pythonPath = with python3.pkgs; [ gpxpy ];

  preInstall = ''
    buildPythonPath "''${pythonPath[*]}"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = {
    description = "Display vector and raster maps, places, routes, and provide navigation instructions with a flexible selection of data and service providers";
    mainProgram = "pure-maps";
    homepage = "https://github.com/rinigus/pure-maps";
    changelog = "https://github.com/rinigus/pure-maps/blob/${src.rev}/NEWS.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.Thra11 ];
    platforms = lib.platforms.linux;
  };
}
