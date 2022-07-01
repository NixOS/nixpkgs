{ lib, stdenv, fetchFromGitHub, cmake, git, gfortran, mpi, blas, liblapack, pkg-config, libGL, libGLU, opencascade, libsForQt5, vtkWithQt5}:

stdenv.mkDerivation rec {
  pname = "elmerfem";
  version = "9.0";

  src = fetchFromGitHub {
    owner = "elmercsc";
    repo = "elmerfem";
    rev = "release-${version}";
    sha256 = "VK7jvu4s5d7k0c39XqY9dEzg/vXtX5Yr/09VcuZVQ9A=";
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
    vtkWithQt5
  ];

  preConfigure = ''
    patchShebangs ./
  '';

  patches = [
    ./patches/0001-fix-import-of-QPainterPath.patch
    ./patches/0002-fem-rename-loopvars-to-avoid-redefinition.patch
    ./patches/0003-ignore-qwt_compat.patch
  ];

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
    homepage = "https://elmerfem.org/";
    description = "A finite element software for multiphysical problems";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wulfsta broke ];
    license = licenses.lgpl21;
  };

}
