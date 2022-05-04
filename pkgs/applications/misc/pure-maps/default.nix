{ lib, mkDerivation, fetchFromGitHub
, cmake, qttools, kirigami2, qtquickcontrols2, qtlocation, qtsensors
, nemo-qml-plugin-dbus, mapbox-gl-qml, s2geometry
, python3, pyotherside
}:

mkDerivation rec {
  pname = "pure-maps";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "pure-maps";
    rev = version;
    hash = "sha256-r36/Vpt4ZIWV1+VhqRBuo4uT7nmEGiFGIt3QGG3ijjs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake python3 qttools python3.pkgs.wrapPython
  ];

  buildInputs = [
    kirigami2 qtquickcontrols2 qtlocation qtsensors
    nemo-qml-plugin-dbus pyotherside mapbox-gl-qml s2geometry
  ];

  cmakeFlags = [ "-DFLAVOR=kirigami" ];

  pythonPath = with python3.pkgs; [ gpxpy ];

  preInstall = ''
    buildPythonPath "$pythonPath"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "Display vector and raster maps, places, routes, and provide navigation instructions with a flexible selection of data and service providers";
    homepage = "https://github.com/rinigus/pure-maps";
    changelog = "https://github.com/rinigus/pure-maps/blob/${src.rev}/NEWS.md";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
