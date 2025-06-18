{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qspeakers";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "be1";
    repo = "qspeakers";
    tag = finalAttrs.version;
    hash = "sha256-zN9Z2t7dKo7Ffe5J9ZOGCpNJUK2RkZfQzjzL5HCmJpg=";
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
