{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gklib,
  metis,
  mpi,
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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;
  buildInputs = [
    gklib
    metis
    mpi
  ];

  configurePhase = ''
    runHook preConfigure

    make config metis_path=${metis} gklib_path=${gklib} prefix=$out \
       shared=${if stdenv.hostPlatform.isStatic then "0" else "1"}

    runHook postConfigure
  '';

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
