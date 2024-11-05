{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtwebengine
, gitUpdater
}:

mkDerivation rec {
  pname = "gitqlient";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "francescmm";
    repo = "gitqlient";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-fHrsDEHEUgQYkZdnSzJ/+gTsV0eX8tOqSlr7vNH6LVs=";
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

  meta = with lib; {
    homepage = "https://github.com/francescmm/GitQlient";
    description = "Multi-platform Git client written with Qt";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
    mainProgram = "gitqlient";
  };
}
