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
  podofo,
  sqlite,
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
# This base is used in horizon-eda and python3Packages.horizon-eda
rec {
  pname = "horizon-eda";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    hash = "sha256-0ikCR10r/WPb+H+Ut2GO6y4A/9bctJLanL/RR4r9GWs=";
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
    podofo
    sqlite
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-fpermissive"
    ];
  };

  CASROOT = opencascade-occt;

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
