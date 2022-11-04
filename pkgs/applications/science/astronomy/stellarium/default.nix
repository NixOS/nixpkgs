{ lib
, stdenv
, fetchFromGitHub
, cmake
, perl
, wrapQtAppsHook
, qtbase
, qtcharts
, qtlocation
, qtmultimedia
, qtscript
, qtserialport
, qtwebengine
, calcmysky
, qxlsx
, indilib
, libnova
}:

stdenv.mkDerivation rec {
  pname = "stellarium";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${version}";
    sha256 = "sha256-ellfBZWOkvlRauuwug96C7P/WjQ6dXiDnT0b3KH5zRM=";
  };

  nativeBuildInputs = [
    cmake
    perl
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtcharts
    qtlocation
    qtmultimedia
    qtscript
    qtserialport
    qtwebengine
    calcmysky
    qxlsx
    indilib
    libnova
  ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace 'SET(CMAKE_INSTALL_PREFIX "''${PROJECT_BINARY_DIR}/Stellarium.app/Contents")' \
                'SET(CMAKE_INSTALL_PREFIX "${placeholder "out"}/Applications/Stellarium.app/Contents")'
  '';

  meta = with lib; {
    description = "Free open-source planetarium";
    homepage = "https://stellarium.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma27 ];
  };
}
