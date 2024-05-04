{ lib, stdenv, fetchFromGitHub, blas, arpack, lapack, blis, gfortran, mpi, vtk, cmake }:

stdenv.mkDerivation rec {
  pname = "elmerfem";
  version = "9.0";
  src = fetchFromGitHub {
    owner = "ElmerCSC";
    repo = "elmerfem";
    rev = "1ed4eecf14703bd1c3adfafd03196642ca0e47e7";
    sha256 = "1bx5p6538hhzcfvak5nfrfm7p10vb034r08wn9jm45j8b39v73np";
  };
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE:STRING=Release"
    "-DWITH_CONTRIB=ON"
    "-DWITH_OpenMP:BOOL=TRUE"
    "-DWITH_MPI:BOOL=TRUE"
    "-DWITH_ScatteredDataInterpolator=ON"
    "-DWITH_ElmerIce:BOOL=TRUE"
    "-DWITH_QT5=TRUE"
    "-DWITH_VTK=ON"
  ];
  nativeBuildInputs = [ gfortran cmake ];

  buildInputs = [ arpack blas lapack mpi vtk ];
  meta = with lib; {
    homepage = "https://www.elmerfem.org";
    description = "Elmer is a finite element software for multiphysical problems";
    mainProgram = "ElmerSolver";
    license = licenses.gpl2;
    maintainers = with maintainers; [ qkqsb ];
    platforms = platforms.unix;
  };
}
