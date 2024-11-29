# Type aliases
# Release = {
#  version: String
#  hash: String
#  supportedGpuTargets: List String
# }

{ autoPatchelfHook
, blas
, cmake
, cudaPackages_11 ? null
, cudaPackages
, cudaSupport ? config.cudaSupport
, fetchurl
, gfortran
, gpuTargets ? [ ] # Non-CUDA targets, that is HIP
, rocmPackages_5
, lapack
, lib
, libpthreadstubs
, magmaRelease
, ninja
, python3
, config
  # At least one back-end has to be enabled,
  # and we can't default to CUDA since it's unfree
, rocmSupport ? !cudaSupport
, static ? stdenv.hostPlatform.isStatic
, stdenv
}:


let
  inherit (lib) getLib lists strings trivial;
  inherit (magmaRelease) version hash supportedGpuTargets;

  # Per https://icl.utk.edu/magma/downloads, support for CUDA 12 wasn't added until 2.7.1.
  # If we're building a version prior to that, use the latest release of the 11.x series.
  effectiveCudaPackages =
    if strings.versionOlder version "2.7.1"
    then cudaPackages_11
    else cudaPackages;

  inherit (effectiveCudaPackages) cudaAtLeast flags cudaOlder;

  # move to newer ROCm version once supported
  rocmPackages = rocmPackages_5;

  # NOTE: The lists.subtractLists function is perhaps a bit unintuitive. It subtracts the elements
  #   of the first list *from* the second list. That means:
  #   lists.subtractLists a b = b - a

  # For ROCm
  # NOTE: The hip.gpuTargets are prefixed with "gfx" instead of "sm" like flags.realArches.
  #   For some reason, Magma's CMakeLists.txt file does not handle the "gfx" prefix, so we must
  #   remove it.
  rocmArches = lists.map (x: strings.removePrefix "gfx" x) rocmPackages.clr.gpuTargets;
  supportedRocmArches = lists.intersectLists rocmArches supportedGpuTargets;
  unsupportedRocmArches = lists.subtractLists supportedRocmArches rocmArches;

  supportedCustomGpuTargets = lists.intersectLists gpuTargets supportedGpuTargets;
  unsupportedCustomGpuTargets = lists.subtractLists supportedCustomGpuTargets gpuTargets;

  # Use trivial.warnIf to print a warning if any unsupported GPU targets are specified.
  gpuArchWarner = supported: unsupported:
    trivial.throwIf (supported == [ ])
      (
        "No supported GPU targets specified. Requested GPU targets: "
        + strings.concatStringsSep ", " unsupported
      )
      supported;

  gpuTargetString = strings.concatStringsSep "," (
    if gpuTargets != [ ] then
    # If gpuTargets is specified, it always takes priority.
      gpuArchWarner supportedCustomGpuTargets unsupportedCustomGpuTargets
    else if rocmSupport then
      gpuArchWarner supportedRocmArches unsupportedRocmArches
    else if cudaSupport then
      [ ] # It's important we pass explicit -DGPU_TARGET to reset magma's defaults
    else
      throw "No GPU targets specified"
  );

  cudaArchitecturesString = flags.cmakeCudaArchitecturesString;
  minArch =
    let
      # E.g. [ "80" "86" "90" ]
      cudaArchitectures = (builtins.map flags.dropDot flags.cudaCapabilities);
      minArch' = builtins.head (builtins.sort strings.versionOlder cudaArchitectures);
    in
    # "75" -> "750"  Cf. https://bitbucket.org/icl/magma/src/f4ec79e2c13a2347eff8a77a3be6f83bc2daec20/CMakeLists.txt#lines-273
    "${minArch'}0";

in

assert (builtins.match "[^[:space:]]*" gpuTargetString) != null;

stdenv.mkDerivation {
  pname = "magma";
  inherit version;

  src = fetchurl {
    name = "magma-${version}.tar.gz";
    url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${version}.tar.gz";
    inherit hash;
  };

  # Magma doesn't have anything which could be run under doCheck, but it does build test suite executables.
  # These are moved to $test/bin/ and $test/lib/ in postInstall.
  outputs = ["out" "test"];

  # Fixup for the python test runners
  postPatch = ''
    patchShebangs ./testing/run_{tests,summarize}.py
    substituteInPlace ./testing/run_tests.py \
      --replace-fail \
        "print >>sys.stderr, cmdp, \"doesn't exist (original name: \" + cmd + \", precision: \" + precision + \")\"" \
        "print(f\"{cmdp} doesn't exist (original name: {cmd}, precision: {precision})\", file=sys.stderr)"
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    ninja
    gfortran
  ] ++ lists.optionals cudaSupport [
    effectiveCudaPackages.cuda_nvcc
  ];

  buildInputs = [
    libpthreadstubs
    lapack
    blas
    python3
    (getLib gfortran.cc) # libgfortran.so
  ] ++ lists.optionals cudaSupport (with effectiveCudaPackages; [
    cuda_cudart # cuda_runtime.h
    libcublas # cublas_v2.h
    libcusparse # cusparse.h
  ] ++ lists.optionals (cudaOlder "11.8") [
    cuda_nvprof # <cuda_profiler_api.h>
  ] ++ lists.optionals (cudaAtLeast "11.8") [
    cuda_profiler_api # <cuda_profiler_api.h>
  ] ++ lists.optionals (cudaAtLeast "12.0") [
    cuda_cccl # <nv/target>
  ]) ++ lists.optionals rocmSupport [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.hipsparse
    rocmPackages.llvm.openmp
  ];

  cmakeFlags = [
    (strings.cmakeFeature "GPU_TARGET" gpuTargetString)
    (strings.cmakeBool "MAGMA_ENABLE_CUDA" cudaSupport)
    (strings.cmakeBool "MAGMA_ENABLE_HIP" rocmSupport)
    (strings.cmakeBool "BUILD_SHARED_LIBS" (!static))
    # Set the Fortran name mangling scheme explicitly. We must set FORTRAN_CONVENTION manually because it will
    # otherwise not be set in NVCC_FLAGS or DEVCCFLAGS (which we cannot modify).
    # See https://github.com/NixOS/nixpkgs/issues/281656#issuecomment-1902931289
    (strings.cmakeBool "USE_FORTRAN" true)
    (strings.cmakeFeature "CMAKE_C_FLAGS" "-DADD_")
    (strings.cmakeFeature "CMAKE_CXX_FLAGS" "-DADD_")
    (strings.cmakeFeature "FORTRAN_CONVENTION" "-DADD_")
  ] ++ lists.optionals cudaSupport [
    (strings.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchitecturesString)
    (strings.cmakeFeature "MIN_ARCH" minArch) # Disarms magma's asserts
  ] ++ lists.optionals rocmSupport [
    (strings.cmakeFeature "CMAKE_C_COMPILER" "${rocmPackages.clr}/bin/hipcc")
    (strings.cmakeFeature "CMAKE_CXX_COMPILER" "${rocmPackages.clr}/bin/hipcc")
  ];

  # Magma doesn't have a test suite we can easily run, just loose executables, all of which require a GPU.
  doCheck = false;

  # Copy the files to the test output and fix the RPATHs.
  postInstall =
    # NOTE: The python scripts aren't copied by CMake into the build directory, so we must copy them from the source.
    # TODO(@connorbaker): This should be handled by having CMakeLists.txt install them, but such a patch is
    # out of the scope of the PR which introduces the `test` output: https://github.com/NixOS/nixpkgs/pull/283777.
    # See https://github.com/NixOS/nixpkgs/pull/283777#discussion_r1482125034 for more information.
    # Such work is tracked by https://github.com/NixOS/nixpkgs/issues/296286.
    ''
      install -Dm755 ../testing/run_{tests,summarize}.py -t "$test/bin/"
    ''
    # Copy core test executables and libraries over to the test output.
    # NOTE: Magma doesn't provide tests for sparse solvers for ROCm, but it does for CUDA -- we put them both in the same
    # install command to avoid the case where a glob would fail to find any files and cause the install command to fail
    # because it has no files to install.
    + ''
      install -Dm755 ./testing/testing_* ./sparse/testing/testing_* -t "$test/bin/"
      install -Dm755 ./lib/lib*test*.* -t "$test/lib/"
    ''
    # All of the test executables and libraries will have a reference to the build directory in their RPATH, which we
    # must remove. We do this by shrinking the RPATH to only include the Nix store. The autoPatchelfHook will take care
    # of supplying the correct RPATH for needed libraries (like `libtester.so`).
    + ''
      find "$test" -type f -exec \
        patchelf \
          --shrink-rpath \
          --allowed-rpath-prefixes "$NIX_STORE" \
          {} \;
    '';

  passthru = {
    inherit cudaSupport rocmSupport gpuTargets;
    cudaPackages = effectiveCudaPackages;
  };

  meta = with lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = "http://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ connorbaker ];

    # Cf. https://bitbucket.org/icl/magma/src/fcfe5aa61c1a4c664b36a73ebabbdbab82765e9f/CMakeLists.txt#lines-20
    broken =
      !(cudaSupport || rocmSupport) # At least one back-end enabled
      || (cudaSupport && rocmSupport) # Mutually exclusive
      || (cudaSupport && cudaOlder "9.0")
      || (cudaSupport && strings.versionOlder version "2.7.1" && cudaPackages_11 == null);
  };
}
