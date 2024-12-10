{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qmake,
  qttools,
  qtbase,
  mpv,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "mpc-qt";
  version = "23.12";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "v${version}";
    hash = "sha256-v22o5QtCY9Z8bPoIkwypG0oTBEPqPFeKZ8cWO+pKCD0=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    mpv
  ];

  postPatch = ''
    substituteInPlace lconvert.pri --replace "qtPrepareTool(LCONVERT, lconvert)" "qtPrepareTool(LCONVERT, lconvert, , , ${qttools}/bin)"
  '';

  postConfigure = ''
    substituteInPlace Makefile --replace ${qtbase}/bin/lrelease ${qttools.dev}/bin/lrelease
  '';

  qmakeFlags = [
    "MPCQT_VERSION=${version}"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Media Player Classic Qute Theater";
    homepage = "https://mpc-qt.github.io";
    license = licenses.gpl2;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ romildo ];
    mainProgram = "mpc-qt";
  };
}
