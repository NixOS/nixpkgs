{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
  fontFaceCache ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plutovg";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutovg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6UW+laVxTYvg+5qC12yA6U6gPKdFQeb7sdDunZ6gcd4=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "PLUTOVG_DISABLE_FONT_FACE_CACHE_LOAD" (!fontFaceCache))
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "plutovg" ];
      versionCheck = true;
    };
  };

  meta = {
    homepage = "https://github.com/sammycage/plutovg/";
    changelog = "https://github.com/sammycage/plutovg/releases/tag/v${finalAttrs.version}";
    description = "Tiny 2D vector graphics library in C";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
    pkgConfigModules = [ "plutovg" ];
  };
})
