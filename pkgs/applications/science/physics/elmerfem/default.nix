{ lib, stdenv, fetchFromGitHub, cmake, git, gfortran, mpi, blas, liblapack, qt4, qwt6_qt4, pkg-config }:

stdenv.mkDerivation rec {
  pname = "elmerfem";
  version = "8.4";

  src = fetchFromGitHub {
    owner = "elmercsc";
    repo = "elmerfem";
    rev = "release-${version}";
    sha256 = "0vk31lplxlng173q8jjcpbyj1gaf98jvkqjvi9077d1nslya7vpm";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ cmake gfortran pkg-config git ];
  buildInputs = [ mpi blas liblapack qt4 qwt6_qt4 ];

  preConfigure = ''
    patchShebangs ./
  '';

  storepath = placeholder "out";

  cmakeFlags = [
  "-DELMER_INSTALL_LIB_DIR=${storepath}/lib"
  "-DWITH_OpenMP:BOOLEAN=TRUE"
  "-DWITH_MPI:BOOLEAN=TRUE"
  "-DWITH_ELMERGUI:BOOLEAN=TRUE"
  "-DCMAKE_INSTALL_LIBDIR=lib"
  "-DCMAKE_INSTALL_INCLUDEDIR=include"
  "-DCMAKE_OpenGL_GL_PREFERENCE=GLVND"
  ];

  patches = [
    ./fix-cmake.patch
  ];

  meta = with lib; {
    homepage = "https://elmerfem.org/";
    description = "A finite element software for multiphysical problems";
    platforms = platforms.unix;
    maintainers = [ maintainers.wulfsta ];
    license = licenses.lgpl21;
  };

}
