{ lib, mkDerivation, fetchFromGitHub, wrapQtAppsHook
, qmake, qttools, kirigami2, qtquickcontrols2, qtlocation, qtsensors
, nemo-qml-plugin-dbus, mapbox-gl-qml, s2geometry
, python3, pyotherside, python3Packages
}:

mkDerivation rec {
  pname = "pure-maps";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "pure-maps";
    rev = version;
    sha256 = "1nviq2pavyxwh9k4kyzqpbzmx1wybwdax4pyd017izh9h6gqnjhs";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake python3 qttools wrapQtAppsHook ];
  buildInputs = [
    kirigami2 qtquickcontrols2 qtlocation qtsensors
    nemo-qml-plugin-dbus pyotherside mapbox-gl-qml s2geometry
  ];
  propagatedBuildInputs = with python3Packages; [ gpxpy pyxdg ];

  postPatch = ''
    substituteInPlace pure-maps.pro \
      --replace '$$[QT_HOST_BINS]/lconvert' 'lconvert'
  '';

  qmakeFlags = [ "FLAVOR=kirigami" ];

  dontWrapQtApps = true;
  postInstall = ''
    wrapQtApp $out/bin/pure-maps \
      --prefix PYTHONPATH : "$out/share"
  '';

  meta = with lib; {
    description = "Display vector and raster maps, places, routes, and provide navigation instructions with a flexible selection of data and service providers";
    homepage = "https://github.com/rinigus/pure-maps";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
