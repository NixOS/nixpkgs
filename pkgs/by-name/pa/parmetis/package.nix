{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gklib,
  metis,
  mpi,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "parmetis";
  version = "4.0.3-unstable-2023-03-26";

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "ParMETIS";
    rev = "8ee6a372ca703836f593e3c450ca903f04be14df";
    hash = "sha256-L9SLyr7XuBUniMH3JtaBrUHIGzVTF5pr014xovQf2cI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    mpi
    metis
    gklib
  ] ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  cmakeFlags = [
    (lib.cmakeBool "OPENMP" true)
    (lib.cmakeBool "SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (lib.cmakeFeature "CMAKE_C_COMPILER" "mpicc")
  ];

  meta = with lib; {
    description = "Parallel Graph Partitioning and Fill-reducing Matrix Ordering";
    longDescription = ''
      MPI-based parallel library that implements a variety of algorithms for
      partitioning unstructured graphs, meshes, and for computing fill-reducing
      orderings of sparse matrices.
      The algorithms implemented in ParMETIS are based on the multilevel
      recursive-bisection, multilevel k-way, and multi-constraint partitioning
      schemes
    '';
    homepage = "https://github.com/KarypisLab/ParMETIS";
    platforms = platforms.all;
    license = licenses.unfree;
    maintainers = [ maintainers.costrouc ];
  };
}
