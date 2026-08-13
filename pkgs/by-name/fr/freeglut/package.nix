{
  lib,
  stdenv,
  fetchurl,
  libice,
  libxext,
  libxi,
  libxrandr,
  libxxf86vm,
  libGLX,
  libGLU,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeglut";
  version = "3.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeglut/freeglut-${finalAttrs.version}.tar.gz";
    hash = "sha256-Z03K/yUBDgnkUK7EWLiHDZ6YxG+ZU420V6tlmzIdmYk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libice
    libxext
    libxi
    libxrandr
    libxxf86vm
    libGLU
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DOPENGL_INCLUDE_DIR=${lib.getInclude libGLX}/include"
    "-DOPENGL_gl_LIBRARY:FILEPATH=${lib.getLib libGLX}/lib/libGL.dylib"
    "-DFREEGLUT_BUILD_DEMOS:BOOL=OFF"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Create and manage windows containing OpenGL contexts";
    longDescription = ''
      FreeGLUT is an open source alternative to the OpenGL Utility Toolkit
      (GLUT) library. GLUT (and hence FreeGLUT) allows the user to create and
      manage windows containing OpenGL contexts on a wide range of platforms
      and also read the mouse, keyboard and joystick functions. FreeGLUT is
      intended to be a full replacement for GLUT, and has only a few
      differences.
    '';
    homepage = "https://freeglut.sourceforge.net/";
    license = lib.licenses.mit;
    pkgConfigModules = [ "glut" ];
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
