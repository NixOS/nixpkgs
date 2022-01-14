{ stdenv
, fetchurl
, lib
, autoconf
, automake
, bison
, blas
, flex
, fftw
, gfortran
, lapack
, libtool_2
, mpi
, suitesparse
, trilinos
  # if compiling with MPI so trilinos must be! Pass the correct one.
, withMPI ? false
}:

stdenv.mkDerivation rec {

  pname = "xyce";
  version = "7.4.0";

  src = fetchurl {
    url = "https://github.com/Xyce/Xyce/archive/refs/tags/Release-${version}.tar.gz";
    sha256 = "14bwr1ki14a8pdjyfj1mpcyyhnwcfab1w4shpzhb4d3q6yvw2srd";
  };

  preConfigure = "./bootstrap";

  configureFlags = [ "CXXFLAGS=-O3"
                     "--enable-xyce-shareable"
                     "--enable-shared"
                     "--enable-stokhos" 
                     "--enable-amesos2" ]
                   ++ lib.optionals withMPI
                     [ "--enable-mpi"
                       "CXX=mpicxx"
                       "CC=mpicc"
                       "F77=mpif77" ];

  nativeBuildInputs = [ autoconf automake gfortran libtool_2 ];

  buildInputs = [ bison blas flex fftw lapack suitesparse trilinos ]
                ++ lib.optionals withMPI [ mpi ];

  # Tests not with source distribution. The separate test suite has
  # many additional dependencies such as Perl (with some packages),
  # Python with numpy, scipy, ...
  doCheck = false;

  meta = with lib; {
    description = "High-performance analog circuit simulator";
    longDescription = ''
      Xyce is a SPICE-compatible, high-performance analog circuit simulator,
      capable of solving extremely large circuit problems by supporting 
      large-scale parallel computing platforms.
    '';
    homepage = "https://xyce.sandia.gov";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fbeffa ];
    platforms = platforms.all;
  };
}
