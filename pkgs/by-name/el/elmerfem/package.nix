{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  mpi,
  blas,
  liblapack,
  pkg-config,
  libGL,
  libGLU,
  opencascade-occt,
  qt6Packages,
  onetbb,
  vtkWithQt6,
  llvmPackages,
}:
stdenv.mkDerivation {
  pname = "elmerfem";
  version = "9.0-unstable-2025-05-25";

  src = fetchFromGitHub {
    owner = "elmercsc";
    repo = "elmerfem";
    rev = "2f7360ddf491c34f19fea9a723f340cca0fbe1d4";
    hash = "sha256-2vzIFGh8+YrMxb5px6+aQyTerOAJmHOh2I7eterY6zI=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    mpi
    blas
    liblapack
    qt6Packages.qtbase
    qt6Packages.qwt
    libGL
    libGLU
    opencascade-occt
    onetbb
    vtkWithQt6
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  preConfigure = ''
    patchShebangs ./
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  cmakeFlags = [
    (lib.cmakeFeature "ELMER_INSTALL_LIB_DIR" "${placeholder "out"}/lib")
    (lib.cmakeBool "WITH_OpenMP" true)
    (lib.cmakeBool "WITH_MPI" true)
    (lib.cmakeBool "WITH_QT6" true)
    (lib.cmakeBool "WITH_OCC" true)
    (lib.cmakeBool "WITH_VTK" true)
    (lib.cmakeBool "WITH_ELMERGUI" true)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_OpenGL_GL_PREFERENCE" "GLVND")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "USE_MACOS_PACKAGE_MANAGER" false)
    (lib.cmakeFeature "QWT_INCLUDE_DIR" "${qt6Packages.qwt}/lib/qwt.framework/Headers")
  ];

  meta = {
    homepage = "https://elmerfem.org";
    description = "Finite element software for multiphysical problems";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      wulfsta
      broke
    ];
    license = lib.licenses.lgpl21;
  };

}
