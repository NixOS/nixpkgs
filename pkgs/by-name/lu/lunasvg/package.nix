{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  plutovg,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lunasvg";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "lunasvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSkYkxdV5L31cIJtH6cVfQU2nguA3BPCQXnIMnColek=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    plutovg
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_PLUTOVG" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      buildInputs = [ plutovg ];
      moduleNames = [ "lunasvg" ];
      versionCheck = true;
    };
  };

  meta = {
    homepage = "https://github.com/sammycage/lunasvg";
    changelog = "https://github.com/sammycage/lunasvg/releases/tag/v${finalAttrs.version}";
    description = "SVG rendering and manipulation library in C++";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "lunasvg" ];
  };
})
