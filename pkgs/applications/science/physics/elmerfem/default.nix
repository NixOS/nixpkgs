{ lib, stdenv, fetchFromGitHub, cmake, git, gfortran, mpi, blas, liblapack, pkg-config, libGL, libGLU, opencascade, libsForQt5, tbb, vtkWithQt5 }:

stdenv.mkDerivation rec {
  pname = "elmerfem";
  version = "unstable-2023-02-03";

  src = fetchFromGitHub {
    owner = "elmercsc";
    repo = pname;
    rev = "39c8784b6e4543a6bf560b5d597e0eec1eb06343";
    hash = "sha256-yyxgFvlS+I4PouDL6eD4ZrXuONTDejCSYKq2AwQ0Iug=";
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
    opencascade
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
    maintainers = with maintainers; [ wulfsta broke ];
    license = licenses.lgpl21;
  };

}
