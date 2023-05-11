{ lib
, stdenv
, cmake
, fetchFromGitHub
, alembic
, qtbase
, qtdeclarative
, qt3d
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qmlalembic";
  version = "unstable-2023-02-08";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = pname;
    rev = "e9ca28118d649ad4e937a85b1c9d33acc178f533";
    hash = "sha256-5FoQTEEOrfljigo69ucX9Sugu3psbJ6A7aSGsFCmsr4=";
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${qtbase.qtQmlPrefix}/.."
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    alembic.dev
    qtbase
    qtdeclarative
    qt3d
  ];

  meta = {
    description = "3D Reconstruction Software";
    homepage = "https://github.com/alicevision/meshroom";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
}
