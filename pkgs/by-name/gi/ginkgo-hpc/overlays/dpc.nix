{ lib }:

_: prev: {
  pname = "${prev.pname}-dpc";
  # nativeBuildInputs = prev.nativeBuildInputs ++ [ oneDPL ];
  # buildInputs = prev.buildInputs ++ [ oneMKL ];

  cmakeFlags = prev.cmakeFlags ++ [
    # (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${dpcpp}/bin/c++")
    # (lib.cmakeFeature "CMAKE_C_COMPILER" "${dpcpp}/bin/cc")
    (lib.cmakeBool "GINKGO_BUILD_DPCPP" true)
    (lib.cmakeBool "GINKGO_FORCE_GPU_AWARE_MPI" true)
  ];

  passthru = {
    inherit (prev.passthru) mpi openmp test example benchmark impureTests;
  };

  # Don't have the deps, someone else can work on Intel stuff
  meta.broken = true;
}
