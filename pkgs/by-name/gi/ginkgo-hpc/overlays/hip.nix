{ lib
, mpi-rocm
, rocmPackages
, rocmUnfree
, hipGPUTargets ? rocmPackages.clr.gpuTargets
}:

_: prev: {
  pname = "${prev.pname}-hip";

  nativeBuildInputs = with rocmPackages; prev.nativeBuildInputs ++ [
    llvm.clang
    clr
  ];

  buildInputs = with rocmPackages; prev.buildInputs ++ [
    rocprim
    rocthrust
    hipblas
    hipsparse
    hiprand
    hipfft
  ] ++ lib.optionals rocmUnfree [
    roctracer # Unfree due to hsa-amd-aqlprofile
  ];

  cmakeFlags = with rocmPackages; prev.cmakeFlags ++ [
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${llvm.clang}/bin/c++")
    (lib.cmakeFeature "CMAKE_C_COMPILER" "${llvm.clang}/bin/cc")
    (lib.cmakeFeature "CMAKE_MODULE_PATH" "${clr}/lib/cmake/hip")
    (lib.cmakeBool "GINKGO_BUILD_HIP" true)
    (lib.cmakeFeature "GINKGO_HIP_AMDGPU" (lib.concatStringsSep ";" hipGPUTargets))
    (lib.cmakeFeature "HIP_PATH" "${clr}")
    (lib.cmakeFeature "HIP_ROOT_DIR" "${clr}")
    (lib.cmakeBool "GINKGO_FORCE_GPU_AWARE_MPI" true)
  ] ++ lib.optionals rocmUnfree [
    (lib.cmakeFeature "ROCTRACER_PATH" "${roctracer}/roctracer") # Unfree due to hsa-amd-aqlprofile
  ];

  postPatch = prev.postPatch + ''
    # `--amdgpu-target` is deprecated
    substituteInPlace cmake/hip.cmake \
      --replace "--amdgpu-target" "--offload-arch"

    # https://github.com/ginkgo-project/ginkgo/issues/1429
    # Not ideal, but it's what we have until there's a real fix
    substituteInPlace hip/CMakeLists.txt \
      --replace "GKO_HIP_JACOBI_MAX_BLOCK_SIZE 64" "GKO_HIP_JACOBI_MAX_BLOCK_SIZE 32"

    # Deprecation spam
    substituteInPlace hip/{base,matrix,solver,test/{base,matrix}}/*.hip.{cpp,hpp} \
      --replace "<hipblas.h>" "<hipblas/hipblas.h>" \
      --replace "<hipsparse.h>" "<hipsparse/hipsparse.h>" \
      --replace "<hipfft.h>" "<hipfft/hipfft.h>" 2>/dev/null
  '';

  passthru = {
    inherit (prev.passthru) test example benchmark impureTests;
    mpi = mpi-rocm;
    openmp = rocmPackages.llvm.openmp;
  };
}
