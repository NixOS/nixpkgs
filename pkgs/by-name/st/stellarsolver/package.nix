{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  cfitsio,
  gsl,
  wcslib,
  withTester ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "stellarsolver";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "rlancaste";
    repo = "stellarsolver";
    rev = finalAttrs.version;
    sha256 = "sha256-ez0YAVEKG42bjRkxhTkYNJTGpPbSvLDf+RzmTJURJyo=";
  };

  nativeBuildInputs = [ cmake ];

  dontWrapQtApps = true;

  buildInputs = [
    qt6.qtbase
    cfitsio
    gsl
    wcslib
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "BUILD_TESTER" withTester)
    (lib.strings.cmakeBool "USE_QT5" false)
  ];

  meta = {
    homepage = "https://github.com/rlancaste/stellarsolver";
    description = "Astrometric plate solving library";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      returntoreality
    ];
    platforms = lib.platforms.unix;
  };
})
