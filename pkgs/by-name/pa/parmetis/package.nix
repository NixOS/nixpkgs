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
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "ParMETIS";
    # this commit decoupled the build of parmetis from metis/gklib
    rev = "978c43a1e7351f937705de70dd14535487d006bc";
    hash = "sha256-4A5TNBlAlmRKYcWZhWOynDxq//0KWl4rI1GeRYSaMjw=";
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
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "mpicxx")
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
