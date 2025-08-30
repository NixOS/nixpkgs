{
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libsForQt5,
  qt6Packages,
  openscenegraph,
  stdenv,

  qt6Support ? false,
}:
let
  qt = if qt6Support then qt6Packages else libsForQt5;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "osgQt";
  version = "3.5.7-unstable-2021-04-05";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "osgQt";
    rev = "8fa9e2aed141488fa0818219f29e7ee9c7e667b0";
    hash = "sha256-i6/6jOK7goIYKxKe0dtUa4dE4nLcYzFy2k+qKMiYMzk=";
  };

  patches = lib.optionals qt6Support [
    (fetchpatch {
      url = "https://github.com/DeadParrot/osgQt/commit/c4d48d1f05fda1dcb210418b89c75edf2157d85b.patch";
      hash = "sha256-oq6R7BwXagXhxz3ClkD4qVSaNyfKawU5JK4Pq3QBKvU=";
    })
    (fetchpatch {
      url = "https://github.com/DeadParrot/osgQt/commit/acbcdbec0026ad4b3979b6fa9311a1576f06b2cc.patch";
      hash = "sha256-OJSITx/Lr4DwWM9vrLUiKh/cXZW+3jSAyNXLeyHPm3k=";
    })
  ];

  postPatch = lib.optionalString qt6Support ''
    mv include/osgQOpenGL/GraphicsWindowEx{,.h}
    mv include/osgQOpenGL/OSGRenderer{,.h}
    mv include/osgQOpenGL/RenderStageEx{,.h}
    mv include/osgQOpenGL/StateEx{,.h}
    mv include/osgQOpenGL/osgQOpenGLWidget{,.h}
    mv include/osgQOpenGL/osgQOpenGLWindow{,.h}
  '';

  buildInputs = [ qt.qtbase ];

  nativeBuildInputs = [
    cmake
    qt.wrapQtAppsHook
  ];

  propagatedBuildInputs = [ openscenegraph ];

  cmakeFlags = [
    "-DBUILD_OSG_EXAMPLES=OFF"
    "-DDESIRED_QT_VERSION=${if qt6Support then "6" else "5"}"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  meta = {
    description = "Qt bindings for OpenSceneGraph";
    homepage = "https://github.com/openscenegraph/osgQt";
    license = "OpenSceneGraph Public License - free LGPL-based license";
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
