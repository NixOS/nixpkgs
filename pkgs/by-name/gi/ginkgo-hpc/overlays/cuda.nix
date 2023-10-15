{ lib
, mpi-cuda
, cudaPackages
, cudaGPUTargets ? with cudaPackages.cudaFlags; (map dropDot cudaCapabilities)
}:

_: prev: {
  pname = "${prev.pname}-cuda";
  nativeBuildInputs = with cudaPackages; prev.nativeBuildInputs ++ [ cudatoolkit ];

  cmakeFlags = with cudaPackages; prev.cmakeFlags ++ [
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${cudatoolkit.cc}/bin/c++")
    (lib.cmakeFeature "CMAKE_C_COMPILER" "${cudatoolkit.cc}/bin/cc")
    (lib.cmakeBool "GINKGO_BUILD_CUDA" true)
    (lib.cmakeFeature "GINKGO_CUDA_ARCHITECTURES" (lib.concatStringsSep ";" cudaGPUTargets))
    (lib.cmakeBool "GINKGO_FORCE_GPU_AWARE_MPI" true)
    (lib.cmakeBool "GINKGO_WITH_CCACHE" false)
  ];

  passthru = {
    inherit (prev.passthru) openmp test example benchmark impureTests;
    mpi = mpi-cuda;
  };
}
