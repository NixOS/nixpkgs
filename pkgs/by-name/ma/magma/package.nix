{
  autoPatchelfHook,
  blas,
  cmake,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  fetchurl,
  gfortran,
  gpuTargets ? [ ], # Non-CUDA targets, that is HIP
  rocmPackages,
  lapack,
  lib,
  libpthreadstubs,
  ninja,
  python3,
  config,
  # At least one back-end has to be enabled,
  # and we can't default to CUDA since it's unfree
  rocmSupport ? !cudaSupport,
  runCommand,
  static ? stdenv.hostPlatform.isStatic,
  stdenv,
  writeShellApplication,
}:

let
  inherit (lib)
    getLib
    lists
    strings
    trivial
    ;

  inherit (cudaPackages) cudaAtLeast flags cudaOlder;

  supportedGpuTargets = [
    "700"
    "701"
    "702"
    "703"
    "704"
    "705"
    "801"
    "802"
    "803"
    "805"
    "810"
    "900"
    "902"
    "904"
    "906"
    "908"
    "909"
    "90c"
    "1010"
    "1011"
    "1012"
    "1030"
    "1031"
    "1032"
    "1033"
  ];

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
  gpuArchWarner =
    supported: unsupported:
    trivial.throwIf (supported == [ ]) (
      "No supported GPU targets specified. Requested GPU targets: "
      + strings.concatStringsSep ", " unsupported
    ) supported;

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
      cudaArchitectures = (builtins.map flags.dropDots flags.cudaCapabilities);
      minArch' = builtins.head (builtins.sort strings.versionOlder cudaArchitectures);
    in
    # "75" -> "750"  Cf. https://github.com/icl-utk-edu/magma/blob/v2.9.0/CMakeLists.txt#L200-L201
    "${minArch'}0";

in

assert (builtins.match "[^[:space:]]*" gpuTargetString) != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "magma";
  version = "2.9.0";

  src = fetchurl {
    url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${finalAttrs.version}.tar.gz";
    hash = "sha256-/3f9Nyaz3+w7+1V5CwZICqXMOEOWwts1xW/a5KgsZBw=";
  };

  # Magma doesn't have anything which could be run under doCheck, but it does build test suite executables.
  # These are moved to $test/bin/ and $test/lib/ in postInstall.
  outputs = [
    "out"
    "test"
  ];

  postPatch = ''
    # For rocm version script invoked by cmake
    patchShebangs tools/
    # Fixup for the python test runners
    patchShebangs ./testing/run_{tests,summarize}.py
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    ninja
    gfortran
  ]
  ++ lists.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    libpthreadstubs
    lapack
    blas
    python3
    (getLib gfortran.cc) # libgfortran.so
  ]
  ++ lists.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cccl # <nv/target> and <cuda/std/type_traits>
      cuda_cudart # cuda_runtime.h
      libcublas # cublas_v2.h
      libcusparse # cusparse.h
      cuda_profiler_api # <cuda_profiler_api.h>
    ]
  )
  ++ lists.optionals rocmSupport (
    with rocmPackages;
    [
      clr
      hipblas
      hipsparse
      llvm.openmp
    ]
  );

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
  ]
  ++ lists.optionals cudaSupport [
    (strings.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchitecturesString)
    (strings.cmakeFeature "MIN_ARCH" minArch) # Disarms magma's asserts
  ]
  ++ lists.optionals rocmSupport [
    # Can be removed once https://github.com/icl-utk-edu/magma/pull/27 is merged
    # Can't easily apply the PR as a patch because we rely on the tarball with pregenerated
    # hipified files ∴ fetchpatch of the PR will apply cleanly but fail to build
    (strings.cmakeFeature "ROCM_CORE" "${rocmPackages.clr}")
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
    inherit
      cudaPackages
      cudaSupport
      rocmSupport
      gpuTargets
      ;
    testers = {
      all =
        let
          magma = finalAttrs.finalPackage;
        in
        writeShellApplication {
          derivationArgs = {
            __structuredAttrs = true;
            strictDeps = true;
          };
          name = "magma-testers-all";
          text = ''
            logWithDate() {
              printf "%s: %s\n" "$(date --utc --iso-8601=seconds)" "$*"
            }

            isIgnoredTest() {
              case $1 in
                # Skip the python scripts
                *.py) return 0 ;;

                # These test require files, so we skip them
                testing_?io) ;&
                testing_?madd) ;&
                testing_?matrix) ;&
                testing_?matrixcapcup) ;&
                testing_?matrixinfo) ;&
                testing_?mcompressor) ;&
                testing_?mconverter) ;&
                testing_?preconditioner) ;&
                testing_?solver) ;&
                testing_?solver_rhs) ;&
                testing_?solver_rhs_scaling) ;&
                testing_?sort) ;&
                testing_?spmm) ;&
                testing_?spmv) ;&
                testing_?spmv_check) ;&
                testing_?sptrsv) ;&
                testing_dsspmv_mixed) ;&
                testing_zcspmv_mixed)
                  logWithDate "skipping $1 because it requires input"
                  return 0
                  ;;

                # These test require outputing to files, so we skip them
                testing_?print)
                  logWithDate "skipping $1 because it requires creating output"
                  return 0
                  ;;

                # These test succeed but exit with a non-zero code
                testing_[cdz]gglse) ;&
                testing_sgemm_fp16)
                  logWithDate "skipping $1 because has a non-zero exit code"
                  return 0
                  ;;

                # These test have memory freeing/allocation errors:
                testing_?mdotc)
                  logWithDate "skipping $1 because it fails to allocate or free memory"
                  return 0
                  ;;

                # Test is not ignored otherwise.
                *) return 1 ;;
              esac
            }

            runTests() {
              local -nr outputArray="$1"
              local -i programExitCode=0
              local file

              # TODO: Collect and sort filenames prior to iterating so the order isn't dependent on the filesystem.
              for file in "${magma.test}"/bin/*; do
                if isIgnoredTest "$(basename "$file")"; then
                  continue
                fi

                logWithDate "Starting $file"

                # Since errexit is set, we need to reset programExitCode every iteration and use an OR
                # to set it only when the test fails (which should not fail, avoiding tripping errexit).
                programExitCode=0

                # A number of test cases require an input <=128, so we set the range to include [128, 1024].
                # Batch is kept small to keep tests fast.
                "$file" --range 128:1024:896 --batch 32 || programExitCode=$?

                logWithDate "Finished $file with exit code $programExitCode"

                if ((programExitCode)); then
                  outputArray+=("$file")
                fi
              done
            }

            main() {
              local -a failedPrograms=()
              runTests failedPrograms

              if ((''${#failedPrograms[@]})); then
                logWithDate "The following programs had non-zero exit codes:"
                for file in "''${failedPrograms[@]}"; do
                  # Using echo to avoid printing the date
                  echo "- $file"
                done
                logWithDate "Exiting with code 1 because at least one test failed."
                exit 1
              fi

              logWithDate "All tests passed!"
              exit 0
            }

            main
          '';
          runtimeInputs = [ magma.test ];
        };
    };
    tests = {
      all =
        runCommand "magma-tests-all"
          {
            __structuredAttrs = true;
            strictDeps = true;
            nativeBuildInputs = [ finalAttrs.passthru.testers.all ];
            requiredSystemFeatures = lib.optionals cudaSupport [ "cuda" ];
          }
          ''
            if magma-testers-all; then
              touch "$out"
            else
              exit 1
            fi
          '';
    };
  };

  meta = {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = lib.licenses.bsd3;
    homepage = "https://icl.utk.edu/magma/";
    changelog = "https://github.com/icl-utk-edu/magma/blob/v${finalAttrs.version}/ReleaseNotes";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ connorbaker ];

    # Cf. https://github.com/icl-utk-edu/magma/blob/v2.9.0/CMakeLists.txt#L24-L31
    broken =
      # dynamic CUDA support is broken https://github.com/NixOS/nixpkgs/issues/239237
      (cudaSupport && !static)
      || !(cudaSupport || rocmSupport) # At least one back-end enabled
      || (cudaSupport && rocmSupport); # Mutually exclusive
  };
})
