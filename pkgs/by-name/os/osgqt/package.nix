{
  cmake,
  fetchFromGitHub,
  lib,
  libsForQt5,
  openscenegraph,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osgQt";
  version = "3.5.7-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "osgQt";
    rev = "effd111b747d786d4937de93973188a48eee3412";
    hash = "sha256-+rjy2a266p755Mbfk6jRApiERpOL8axHklK0cYokX40=";
  };

  buildInputs = [ libsForQt5.qtbase ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [ openscenegraph ];

  cmakeFlags = [
    "-DDESIRED_QT_VERSION=5"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  meta = {
    description = "Qt bindings for OpenSceneGraph";
    homepage = "https://github.com/openscenegraph/osgQt";
    license = with lib.licenses; [
      lgpl21Only
      wxWindowsException31
    ];
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
