{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  openscenegraph,
  libsForQt5,
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
    substituteInPlace CMakeLists.txt --replace \
      "FIND_PACKAGE(Qt5Widgets REQUIRED)" \
      "FIND_PACKAGE(Qt5Widgets REQUIRED)
       FIND_PACKAGE(Qt5OpenGL REQUIRED)"
  '';

  meta = with lib; {
    description = "Qt bindings for OpenSceneGraph";
    homepage = "https://github.com/openscenegraph/osgQt";
    license = "OpenSceneGraph Public License - free LGPL-based license";
    maintainers = with maintainers; [ nim65s ];
  };
})
