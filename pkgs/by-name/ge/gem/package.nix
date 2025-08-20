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
  libX11,
  file,
}:

stdenv.mkDerivation rec {
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
    libX11
  ];

  meta = with lib; {
    description = "Graphics Environment for Multimedia";
    homepage = "http://puredata.info/downloads/gem";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      raboof
      carlthome
    ];
    platforms = platforms.linux;
  };
}
