{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
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
}:
let
  opencascade-occt = opencascade-occt_7_6;
in
stdenv.mkDerivation rec {
  pname = "elmerfem";
  version = "unstable-2023-09-18";

  src = fetchFromGitHub {
    owner = "elmercsc";
    repo = pname;
    rev = "0fcced06f91c93f44557efd6a5f10b2da5c7066c";
    hash = "sha256-UuARDYW7D3a4dB6I86s2Ed5ecQxc+Y/es3YIeF2VyTc=";
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
  ];

  preConfigure = ''
    patchShebangs ./
  '';

  storepath = placeholder "out";

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
  ];

  meta = with lib; {
    homepage = "https://elmerfem.org";
    description = "A finite element software for multiphysical problems";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      wulfsta
      broke
    ];
    license = licenses.lgpl21;
  };

}
