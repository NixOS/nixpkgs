{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  qt6Packages,
  alglib,
  gdal,
  proj,
  routino,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmapshack";
<<<<<<< HEAD
  version = "1.19.0";
=======
  version = "1.18.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = "qmapshack";
    tag = "V_${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-g/csg44pyjLCavRNu/WgNY3sXW0hncB1xpAPhvyuD60=";
=======
    hash = "sha256-vvpDjGFzkbsM/QUiU9EURuU0babWYL1gLzWTqJbHu0c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alglib
    gdal
    proj
    routino
    qt6.qtwebengine
    qt6Packages.quazip
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ALGLIB_INCLUDE_DIRS" "${alglib}/include/alglib")
    (lib.cmakeFeature "ALGLIB_LIBRARIES" "alglib3")
    (lib.cmakeFeature "ROUTINO_XML_PATH" "${routino}/share/routino")
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
    changelog = "https://github.com/Maproom/qmapshack/blob/V_${finalAttrs.version}/changelog.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      sikmir
    ];
    platforms = lib.platforms.linux;
  };
})
