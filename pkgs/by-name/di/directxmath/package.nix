{
  stdenv,
  lib,
  fetchFromGitHub,

  cmake,
  ninja,

  withXDSP ? false, # Build XDSP math
  withSHMath ? false, # Build Spherical Harmonics math
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "directxmath";
  version = "3.20"; # DIRECTXMATH_VERSION in CMakeLists.txt

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXMath";
    tag = "apr2025";
    hash = "sha256-lOvDK7/ij2GArWCJRkvrBXOA4qxCaQfYNZGcnhY5pgo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_XDSP" withXDSP)
    (lib.cmakeBool "BUILD_SHMATH" withSHMath)
  ];

  meta = {
    description = "SIMD C++ math library";
    homepage = "https://github.com/microsoft/DirectXMath";
    changelog = "https://github.com/microsoft/DirectXMath/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ griffi-gh ];
    platforms = lib.platforms.all;
  };
})
