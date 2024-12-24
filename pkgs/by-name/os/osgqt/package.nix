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
  version = "3.5.7";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "osgQt";
    rev = finalAttrs.version;
    hash = "sha256-iUeIqRDlcAHdKXWAi4WhEaOCxa7ZivQw0K5E7ccEKnM=";
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

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "FIND_PACKAGE(Qt5Widgets REQUIRED)" \
      "FIND_PACKAGE(Qt5Widgets REQUIRED)
       FIND_PACKAGE(Qt5OpenGL REQUIRED)"
  '';

  meta = {
    description = "Qt bindings for OpenSceneGraph";
    homepage = "https://github.com/openscenegraph/osgQt";
    license = "OpenSceneGraph Public License - free LGPL-based license";
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
