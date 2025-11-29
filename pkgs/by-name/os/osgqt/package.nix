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
  version = "3.5.7-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "osgQt";
    rev = "effd111b747d786d4937de93973188a48eee3412";
    hash = "sha256-+rjy2a266p755Mbfk6jRApiERpOL8axHklK0cYokX40=";
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
    license = with lib.licenses; [
      lgpl21Only
      wxWindowsException31
    ];
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
