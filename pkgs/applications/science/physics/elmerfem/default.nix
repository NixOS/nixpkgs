{ blas
, cmake
, fetchFromGitHub
, gfortran
, git
, lib
, liblapack
, libsForQt5
, libGL
, libGLU
, mpi
, opencascade
, pkg-config
, stdenv
, vtkWithQt5
, libtiff
, libSM
, libXt
, tbb
}:

stdenv.mkDerivation rec {
  pname = "elmerfem";
  version = "unstable-2022-08-30";

  src = fetchFromGitHub {
    owner = "elmercsc";
    repo = "elmerfem";
    rev = "3eafebb4a0287c435376207e15003bf32ffb11e3";
    hash = "sha256-2lVJmbFBDnUo+bw/AILzUncOJM4B7eAW0mosmsAWANI=";
  };

  cmakeFlags = [
    "-DELMER_INSTALL_LIB_DIR=${placeholder "out"}/lib"
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

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    cmake
    gfortran
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    blas
    liblapack
    libsForQt5.qtbase
    libsForQt5.qtscript
    libsForQt5.qwt
    libGL
    libGLU
    mpi
    opencascade
    vtkWithQt5
    libtiff
    libSM
    libXt
    tbb
  ];

  meta = with lib; {
    homepage = "https://elmerfem.org/";
    description = "A finite element software for multiphysical problems";
    platforms = platforms.unix;
    maintainers = with maintainers; [ broke wulfsta ];
    license = licenses.lgpl21;
    mainProgram = "ElmerGUI";
  };
}
