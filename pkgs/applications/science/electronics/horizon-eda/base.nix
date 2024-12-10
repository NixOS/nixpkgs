{
  lib,
  cppzmq,
  curl,
  fetchFromGitHub,
  glm,
  gtkmm3,
  libarchive,
  libepoxy,
  libgit2,
  librsvg,
  libuuid,
  opencascade-occt_7_6,
  pkg-config,
  podofo,
  sqlite,
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
# This base is used in horizon-eda and python3Packages.horizon-eda
rec {
  pname = "horizon-eda";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    hash = "sha256-UcjbDJR6shyETpanNkRoH8LF8r6gFjsyNHVSCMHKqS8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cppzmq
    curl
    glm
    gtkmm3
    libarchive
    libepoxy
    libgit2
    librsvg
    libuuid
    opencascade-occt
    podofo
    sqlite
  ];

  CASROOT = opencascade-occt;

  meta = with lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage = "https://horizon-eda.org";
    maintainers = with maintainers; [
      guserav
      jue89
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
