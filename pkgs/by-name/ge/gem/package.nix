{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  puredata,
  libGL,
  libGLU,
  glew,
  libglut,
  libv4l,
  libx11,
  file,
}:

stdenv.mkDerivation {
  pname = "gem-unstable";
  version = "2023-07-28";

  src = fetchFromGitHub {

    owner = "umlaeute";
    repo = "Gem";
    rev = "4ec12eef8716822c68f7c02a5a94668d2427037d";
    hash = "sha256-Y/Z7oJdKGd7+aSk8eAN9qu4ss+BOvzaXWpWGjfJqGJ8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    file
    pkg-config
  ];

  buildInputs = [
    puredata
    libGL
    libGLU
    glew
    libglut
    libv4l
    libx11
  ];

  meta = {
    description = "Graphics Environment for Multimedia";
    homepage = "http://puredata.info/downloads/gem";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      raboof
      carlthome
    ];
    platforms = lib.platforms.linux;
  };
}
