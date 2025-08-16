{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitqlient";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "francescmm";
    repo = "gitqlient";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-gfWky5KTSj+5FC++QIVTJbrDOYi/dirTzs6LvTnO74A=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtwebengine
  ];

  qmakeFlags = [
    "GitQlient.pro"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://github.com/francescmm/GitQlient";
    description = "Multi-platform Git client written with Qt";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
    mainProgram = "gitqlient";
  };
})
