{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtwebengine,
  gitUpdater,
}:

mkDerivation rec {
  pname = "gitqlient";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "francescmm";
    repo = "gitqlient";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-gfWky5KTSj+5FC++QIVTJbrDOYi/dirTzs6LvTnO74A=";
  };

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtwebengine
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
}
