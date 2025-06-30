{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  plutovg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lunasvg";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "lunasvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1Cj6En0XedAeNPsLWCedxiiq8xPdJ4VpKmF4vYu4SC8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    plutovg
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_PLUTOVG" true)
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"

  ];

  meta = {
    homepage = "https://github.com/sammycage/lunasvg";
    changelog = "https://github.com/sammycage/lunasvg/releases/tag/v${finalAttrs.version}";
    description = "SVG rendering and manipulation library in C++";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
    platforms = lib.platforms.all;
  };
})
