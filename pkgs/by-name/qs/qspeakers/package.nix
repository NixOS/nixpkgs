{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qspeakers";
  version = "1.6.10";

  src = fetchFromGitHub {
    owner = "be1";
    repo = "qspeakers";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-ab3+lw3F0CU8OLa7V4itPZsWKCV+6DoUvmFEqhAdklw=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtcharts
    libsForQt5.qttools
  ];

  meta = {
    description = "Loudspeaker enclosure designer";
    homepage = "https://github.com/be1/qspeakers";
    license = lib.licenses.gpl3Plus;
    mainProgram = "qspeakers";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
