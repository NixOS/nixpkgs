{ lib
, stdenv
, fetchFromGitHub
, autoAddDriverRunpath
, catch2
, cmake
, ninja
, cudaPackages_11_8
, cudaPackages_12
, boost
, fmt_9
, git
, jsoncpp
, libevent
, plog
, python3
, symlinkJoin
, tclap_1_4
, yaml-cpp
}:
let
  # DCGM depends on 2 different versions of CUDA at the same time.
  # The runtime closure, thankfully, is quite small as it does not
  # include the CUDA libraries.
  cudaPackageSets = [
    cudaPackages_11_8
    cudaPackages_12
  ];

  # Select needed redist packages from cudaPackages
  # C.f. https://github.com/NVIDIA/DCGM/blob/7e1012302679e4bb7496483b32dcffb56e528c92/dcgmbuild/scripts/0080_cuda.sh#L24-L39
  getCudaPackages = p: with p; [
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cuda_nvml_dev
    libcublas
    libcufft
    libcurand
  ];

  # Builds CMake flags to add CUDA paths for include and lib.
  mkCudaFlags = cudaPackages:
    let
      version = cudaPackages.cudaMajorVersion;
      # The DCGM CMake assumes that the folder containing cuda.h contains all headers, so we must
      # combine everything together for headers to work.
      headers = symlinkJoin {
        name = "cuda-headers-combined-${version}";
        paths = lib.map (pkg: "${lib.getInclude pkg}/include") (getCudaPackages cudaPackages);
      };
    in [
      (lib.cmakeFeature "CUDA${version}_INCLUDE_DIR" "${headers}")
      (lib.cmakeFeature "CUDA${version}_LIBS" "${cudaPackages.cuda_cudart.stubs}/lib/stubs/libcuda.so")
      (lib.cmakeFeature "CUDA${version}_STATIC_LIBS" "${lib.getLib cudaPackages.cuda_cudart}/lib/libcudart.so")
      (lib.cmakeFeature "CUDA${version}_STATIC_CUBLAS_LIBS" (lib.concatStringsSep ";" [
        "${lib.getLib cudaPackages.libcublas}/lib/libcublas.so"
        "${lib.getLib cudaPackages.libcublas}/lib/libcublasLt.so"
      ]))
    ];
in stdenv.mkDerivation rec {
  pname = "dcgm";
  version = "3.3.9"; # N.B: If you change this, be sure prometheus-dcgm-exporter supports this version.

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "DCGM";
    rev = "refs/tags/v${version}";
    hash = "sha256-PysxuN5WT7GB0oOvT5ezYeOau6AMVDDWE5HOAcmqw/Y=";
  };

  patches = [
    ./fix-includes.patch
    ./dynamic-libs.patch
  ];

  hardeningDisable = [ "all" ];

  strictDeps = true;

  nativeBuildInputs = [
    # autoAddDriverRunpath does not actually depend on or incur any dependency
    # of cudaPackages. It merely adds an impure, non-Nix PATH to the RPATHs of
    # executables that need to use cuda at runtime.
    autoAddDriverRunpath

    cmake
    ninja
    git
    python3
  ];

  buildInputs = [
    # Header-only
    boost
    catch2
    plog.dev
    tclap_1_4

    fmt_9
    yaml-cpp
    jsoncpp
    libevent
  ];

  # Add our paths to the CMake flags so FindCuda.cmake can find them.
  cmakeFlags = lib.concatMap mkCudaFlags cudaPackageSets;

  # Lots of dodgy C++.
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ctest -j $NIX_BUILD_CORES --output-on-failure --exclude-regex ${
      lib.escapeShellArg (
        lib.concatMapStringsSep "|" (test: "^${lib.escapeRegex test}$") [
          "DcgmModuleSysmon Watches"
          "DcgmModuleSysmon maxSampleAge"
          "DcgmModuleSysmon::CalculateCoreUtilization"
          "DcgmModuleSysmon::ParseProcStatCpuLine"
          "DcgmModuleSysmon::ParseThermalFileContentsAndStore"
          "DcgmModuleSysmon::PopulateTemperatureFileMap"
          "DcgmModuleSysmon::ReadCoreSpeed"
          "DcgmModuleSysmon::ReadTemperature"
          "Sysmon: initialize module"
        ]
      )
    }

    runHook postCheck
  '';

  disallowedReferences = lib.concatMap getCudaPackages cudaPackageSets;

  meta = with lib; {
    description = "Data Center GPU Manager (DCGM) is a daemon that allows users to monitor NVIDIA data-center GPUs";
    homepage = "https://developer.nvidia.com/dcgm";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
    mainProgram = "dcgmi";
    platforms = platforms.linux;
  };
}
