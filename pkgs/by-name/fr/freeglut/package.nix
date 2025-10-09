{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libICE,
  libXext,
  libXi,
  libXrandr,
  libXxf86vm,
  libGLX,
  libGLU,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeglut";
  version = "3.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeglut/freeglut-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-nD1NZRb7+gKA7ck8d2mPtzA+RDwaqvN9Jp4yiKbD6lI=";
  };

  patches = [
    (fetchpatch {
      name = "freeglut-fix-cmake-4.patch";
      url = "https://github.com/freeglut/freeglut/commit/2294389397912c9a6505a88221abb7dca0a4fb79.patch";
      hash = "sha256-buNhlVUbDekklnar6KFWN/GUKE+jMEqTGrY3LY0LwVs=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libICE
    libXext
    libXi
    libXrandr
    libXxf86vm
    libGLU
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DOPENGL_INCLUDE_DIR=${lib.getInclude libGLX}/include"
    "-DOPENGL_gl_LIBRARY:FILEPATH=${lib.getLib libGLX}/lib/libGL.dylib"
    "-DFREEGLUT_BUILD_DEMOS:BOOL=OFF"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
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
    license = licenses.mit;
    pkgConfigModules = [ "glut" ];
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
})
