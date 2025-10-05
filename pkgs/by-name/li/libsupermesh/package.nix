{
  lib,
  stdenv,
  fetchFromGitHub,
  validatePkgConfig,
  gfortran,
  mpi,
  cmake,
  ninja,
  libspatialindex,
  mpiCheckPhaseHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsupermesh";
  version = "2025.4";

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "libsupermesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VIGfuSVneCBapZyU0GXyi6isUSdhD2Ylm4mCymSvzbo=";
  };

  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    mpi
    gfortran
    cmake
    ninja
    validatePkgConfig
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  buildInputs = [
    libspatialindex
    gfortran.cc.lib
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ mpiCheckPhaseHook ];

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    homepage = "https://github.com/firedrakeproject/libsupermesh";
    description = "Parallel supermeshing library";
    changelog = "https://github.com/firedrakeproject/libsupermesh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
    pkgConfigModules = [ "libsupermesh" ];
  };
})
