{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  libGL,
  libGLU,
  SDL2,
  SDL2_image,
  fmt,
  gtest,
  libpng,
  libsigcxx,
  argpp,
  geomcpp,
  logmich,
  priocpp,
  strutcpp,
  tinycmmc,
  tinygettext,
  uitest,
  wstsound,
  xdgcpp,
}:

stdenv.mkDerivation {
  pname = "pingus";
  version = "0.7.6-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "Pingus";
    repo = "pingus";
    rev = "b0ceeeeb95428c73b1b81208211535c61acfc5d0";
    sha256 = "sha256-jQYZM7VLqbl9/+QXyswEXdGmwOq/nxRzWARvcDqNM9M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libGL
    libGLU
    SDL2
    SDL2_image
    fmt
    gtest
    libpng
    libsigcxx
    argpp
    geomcpp
    logmich
    priocpp
    strutcpp
    tinycmmc
    tinygettext
    uitest
    wstsound
    xdgcpp
  ];

  cmakeFlags = [
    "-DWARNINGS=ON"
    "-DWERROR=ON"
    "-DBUILD_EXTRA=OFF"
    "-DBUILD_TESTS=OFF"
  ];

  doCheck = true;

  meta = {
    description = "Puzzle game with mechanics similar to Lemmings";
    homepage = "https://pingus.seul.org/";
    mainProgram = "pingus";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      raskin
      SchweGELBin
    ];
    license = lib.licenses.gpl3;
  };
}
