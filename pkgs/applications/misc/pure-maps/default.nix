{ lib, mkDerivation, fetchFromGitHub
, qmake, qttools, kirigami2, qtquickcontrols2, qtlocation, qtsensors
, nemo-qml-plugin-dbus, mapbox-gl-qml, s2geometry
, python3, pyotherside
}:

mkDerivation rec {
  pname = "pure-maps";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "pure-maps";
    rev = version;
    sha256 = "17gfb7rdaadmcdba4mhish0jrz9lmiban6fpzwhyvn8z1rc43zx9";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake python3 qttools python3.pkgs.wrapPython
  ];

  buildInputs = [
    kirigami2 qtquickcontrols2 qtlocation qtsensors
    nemo-qml-plugin-dbus pyotherside mapbox-gl-qml s2geometry
  ];

  postPatch = ''
    substituteInPlace pure-maps.pro \
      --replace '$$[QT_HOST_BINS]/lconvert' 'lconvert'
  '';

  qmakeFlags = [ "FLAVOR=kirigami" ];

  pythonPath = with python3.pkgs; [ gpxpy ];

  preInstall = ''
    buildPythonPath "$pythonPath"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "Display vector and raster maps, places, routes, and provide navigation instructions with a flexible selection of data and service providers";
    homepage = "https://github.com/rinigus/pure-maps";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
