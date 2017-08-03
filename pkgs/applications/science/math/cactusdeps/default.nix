{ stdenv
, fetchurl
, gcc
, gfortran
, fftw
, hdf5
, hdf5-cpp
, hdf5-fortran
, hdf5-mpi
, hwloc
, openblas
, openmpi
, openssl
, zlib
}:

stdenv.mkDerivation {
  name = "cactusdeps-0.1.0";
  # builder = ./builder.sh;
  src = fetchurl {
    url = "mirror://gnu/hello/hello-2.10.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
  };
  inherit gcc;
  inherit gfortran;
  inherit fftw;
  inherit hdf5;
  inherit hdf5-cpp;
  inherit hdf5-fortran;
  inherit hdf5-mpi;
  inherit hwloc;
  inherit openblas;
  inherit openmpi;
  inherit openssl;
  inherit zlib;
}
