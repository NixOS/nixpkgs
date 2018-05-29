{ stdenv, fetchFromGitHub, cmake, gfortran, openmpi, blas, liblapack, qt4}:

stdenv.mkDerivation rec {
  name = "elmer-${version}";
  version = "8.3";
  src = fetchFromGitHub {
    owner = "elmercsc";
    repo = "elmerfem";
    rev = "release-${version}";
    sha256 = "0lkzalag41f3rrd0p4ym14arng4phc7x9zbhgd3qmhfbc93a7bq7";
  };

  buildInputs = [ cmake gfortran openmpi blas liblapack qt4 ];
  configurePhase = ''
    mkdir build
    cd build
    cmake -DWITH_ELMERGUI:BOOL=TRUE \
          -DWITH_MPI:BOOL=TRUE \
          -DCMAKE_INSTALL_PREFIX=$out ../
  '';
  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  meta = {
    description = "An open source multiphysical simulation software";
    longDescription = ''
      Elmer includes physical models of fluid dynamics, structural mechanics, electromagnetics, heat transfer and acoustics, for example.
      These are described by partial differential equations which Elmer solves by the Finite Element Method (FEM).
    '';
    homepage = http://www.elmerfem.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wucke13 ];
  };
}
