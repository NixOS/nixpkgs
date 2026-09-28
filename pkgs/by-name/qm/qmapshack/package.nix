{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  qt6Packages,
  alglib,
  asmjit,
  blend2d,
  gdal,
  proj,
  routino,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmapshack";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = "qmapshack";
    tag = "V_${finalAttrs.version}";
    hash = "sha256-mayPiVV9F6yxDnRyNLrZSiDSPsIRILsaF53Qm7SISg0=";
  };

  patches = [ ./dont_fetch_dependencies.patch ];

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alglib
    asmjit
    blend2d
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
