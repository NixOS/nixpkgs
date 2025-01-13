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
  version = "2.6";

  src = fetchFromGitHub {
    owner = "rlancaste";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-6WDiHaBhi9POtXynGU/eTeuqZSK81JJeuZv4SxOeVoE=";
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
      hjones2199
      returntoreality
    ];
    platforms = platforms.unix;
  };
})
