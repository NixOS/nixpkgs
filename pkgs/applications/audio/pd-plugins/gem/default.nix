{ stdenv
, fetchFromGitHub
, fetchpatch
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
  # The patch below applies to the latest release (v0.94), but then the build
  # fails. I didn't track down what changed between that version and the
  # current master that fixes the build on Nix
  version = "2020-03-26";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "Gem";
    rev = "f38748d71bfca00e4d2b2f31d6c4e3759c03d599";
    sha256 = "0bkky5fk0a836bapslrgzil272iq9y704y7hw254cfq5ffjd4qjy";
  };

  patches = [
    # Update autoconf OpenGL/GLU/GLUT detection scripts
    # https://github.com/umlaeute/Gem/pull/251
    (fetchpatch {
      url = "https://github.com/umlaeute/Gem/commit/343a486c2b5c3427696f77aeabdff440e6590fc7.diff";
      sha256 = "0gkzxv80rgg8lgp9av5qp6xng3ldhnbjz9d6r7ym784fw8yx41yj";
    })
  ];

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
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.raboof ];
    platforms = stdenv.lib.platforms.linux;
  };
}
