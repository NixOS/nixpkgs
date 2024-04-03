{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, lcms
, cmake
, pkg-config
, qt6
, openjpeg
, tbb_2021_8
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdf4qt";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "JakubMelka";
    repo = "PDF4QT";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wZJDMLEaHGBPSToQ+ObSfB5tw/fTIX1i5tmNPmIa7Ck=";
  };

  patches = [
    # lcms2 cmake module only appears when built with vcpkg.
    # We directly search for the corresponding libraries and
    # header files instead.
    ./find_lcms2_path.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtspeech
    lcms
    openjpeg
    tbb_2021_8
  ];

  cmakeFlags = [
    (lib.cmakeBool "PDF4QT_INSTALL_TO_USR" false)
  ];

  meta = {
    description = "Open source PDF editor";
    longDescription = ''
      This software is consisting of PDF rendering library,
      and several applications, such as advanced document
      viewer, command line tool, and document page
      manipulator application. Software is implementing PDF
      functionality based on PDF Reference 2.0.
    '';
    homepage = "https://jakubmelka.github.io";
    license = lib.licenses.lgpl3Only;
    mainProgram = "Pdf4QtViewerLite";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
