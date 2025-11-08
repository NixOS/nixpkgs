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
  version = "2.7";

  src = fetchFromGitHub {
    owner = "rlancaste";
    repo = "stellarsolver";
    rev = finalAttrs.version;
    sha256 = "sha256-tASjV5MZ1ClumZqu/R61b6XE9CGTuVFfpxyC89fwN9o=";
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

  meta = with lib; {
    homepage = "https://github.com/rlancaste/stellarsolver";
    description = "Astrometric plate solving library";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      returntoreality
    ];
    platforms = platforms.unix;
  };
})
