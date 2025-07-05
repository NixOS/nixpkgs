{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  wrapQtAppsHook,
  qtscript,
  qtwebengine,
  gdal,
  proj,
  routino,
  quazip,
}:

stdenv.mkDerivation rec {
  pname = "qmapshack";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = "qmapshack";
    rev = "V_${version}";
    hash = "sha256-wqztKmaUxY3qd7IgPM7kV7x0BsrTMTX3DbcdM+lsarI=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtscript
    qtwebengine
    gdal
    proj
    routino
    quazip
  ];

  cmakeFlags = [
    "-DROUTINO_XML_PATH=${routino}/share/routino"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        gdal
        routino
      ]
    }"
  ];

  meta = {
    description = "Consumer grade GIS software";
    homepage = "https://github.com/Maproom/qmapshack";
    changelog = "https://github.com/Maproom/qmapshack/blob/V_${version}/changelog.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      sikmir
    ];
    platforms = with lib.platforms; linux;
  };
}
