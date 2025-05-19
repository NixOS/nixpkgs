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
  opencascade-occt_7_6,
  libsForQt5,
  tbb,
  vtkWithQt5,
  llvmPackages,
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
stdenv.mkDerivation rec {
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
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    mpi
    blas
    liblapack
    libsForQt5.qtbase
    libsForQt5.qtscript
    libsForQt5.qwt
    libGL
    libGLU
    opencascade-occt
    tbb
    vtkWithQt5
  ] ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  preConfigure = ''
    patchShebangs ./
  '';

  storepath = placeholder "out";

  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  cmakeFlags = [
    "-DELMER_INSTALL_LIB_DIR=${storepath}/lib"
    "-DWITH_OpenMP:BOOLEAN=TRUE"
    "-DWITH_MPI:BOOLEAN=TRUE"
    "-DWITH_QT5:BOOLEAN=TRUE"
    "-DWITH_OCC:BOOLEAN=TRUE"
    "-DWITH_VTK:BOOLEAN=TRUE"
    "-DWITH_ELMERGUI:BOOLEAN=TRUE"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_OpenGL_GL_PREFERENCE=GLVND"
    "-DUSE_MACOS_PACKAGE_MANAGER=False"
  ];

  meta = with lib; {
    homepage = "https://elmerfem.org";
    description = "Finite element software for multiphysical problems";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      wulfsta
      broke
    ];
    license = licenses.lgpl21;
  };

}
