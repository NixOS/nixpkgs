{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  metis,
  mpi,
}:

stdenv.mkDerivation {
  pname = "parmetis";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "ParMETIS";
    rev = "d90a2a6cf08d1d35422e060daa28718376213659";
    hash = "sha256-22YQxwC0phdMLX660wokRgmAif/9tRbUmQWwNMZ//7M=";
  };

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;
  buildInputs = [ mpi ];

  configurePhase = ''
    tar xf ${metis.src}
    mv metis-* metis
    make config metis_path=metis gklib_path=metis/GKlib prefix=$out
  '';

  meta = with lib; {
    description = "MPI-based parallel library for partitioning unstructured graphs, meshes, and for computing fill-reducing orderings of sparse matrices";
    homepage = "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview";
    platforms = platforms.all;
    license = licenses.unfree;
    maintainers = [ maintainers.costrouc ];
  };
}
