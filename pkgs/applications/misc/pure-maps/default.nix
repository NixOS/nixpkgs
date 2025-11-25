{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  qttools,
  kirigami2,
  qtquickcontrols2,
  qtlocation,
  qtsensors,
  nemo-qml-plugin-dbus,
  mapbox-gl-qml,
  s2geometry,
  python3,
  pyotherside,
}:

mkDerivation rec {
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
    qttools
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    kirigami2
    qtquickcontrols2
    qtlocation
    qtsensors
    nemo-qml-plugin-dbus
    pyotherside
    mapbox-gl-qml
    s2geometry
  ];

  cmakeFlags = [ "-DFLAVOR=kirigami" ];

  pythonPath = with python3.pkgs; [ gpxpy ];

  preInstall = ''
    buildPythonPath "$pythonPath"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "Display vector and raster maps, places, routes, and provide navigation instructions with a flexible selection of data and service providers";
    mainProgram = "pure-maps";
    homepage = "https://github.com/rinigus/pure-maps";
    changelog = "https://github.com/rinigus/pure-maps/blob/${src.rev}/NEWS.md";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
