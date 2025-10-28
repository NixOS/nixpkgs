{
  lib,
  cmake,
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
  meson,
  ninja,
  opencascade-occt_7_6,
  pkg-config,
  podofo_0_10,
  sqlite,
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
# This base is used in horizon-eda and python3Packages.horizon-eda
rec {
  pname = "horizon-eda";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    hash = "sha256-gigfwam7+KvmGAxex7Bi7a8xAmiNZ+YBZ5iMXneD4cw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
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
    podofo_0_10
    sqlite
  ];

  env = {
    CASROOT = opencascade-occt;
  };

  meta = {
    description = "Free EDA software to develop printed circuit boards";
    homepage = "https://horizon-eda.org";
    maintainers = with lib.maintainers; [
      guserav
      jue89
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
