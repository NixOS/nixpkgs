{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, puredata
, libGL
, libGLU
, glew
, freeglut
, libv4l
, libX11
, file
 }:

stdenv.mkDerivation rec {
  pname = "gem-unstable";
  version = "2020-09-22";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "Gem";
    rev = "2edfde4f0587e72ef325e7f53681936dcc19655b";
    sha256 = "0k5sq128wxi2qhaidspkw310pdgysxs47agv09pkjgvch2n4d5dq";
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
    freeglut
    libv4l
    libX11
  ];

  meta = {
    description = "Graphics Environment for Multimedia";
    homepage = "http://puredata.info/downloads/gem";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.raboof ];
    platforms = lib.platforms.linux;
  };
}
