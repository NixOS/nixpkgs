{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # buildInputs
  glfw3,
  libGL,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "box2d-lite";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d-lite";
    rev = "refs/tags/${version}";
    hash = "sha256-XilbE1HsDgpTvmz2EmcF9OZBHkabNxuBAo08al0Zixo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    glfw3
    libGL
    libX11
  ];

  meta = {
    description = "A small 2D physics engine";
    homepage = "https://github.com/erincatto/box2d-lite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "box2d-lite";
    platforms = lib.platforms.all;
  };
}
