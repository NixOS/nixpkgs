{
  lib,
  stdenv,
  fetchFromGitHub,
  autoAddDriverRunpath,
  catch2_3,
  cmake,
  ctestCheckHook,
  coreutils,
  mpi,
  mpiCheckPhaseHook,
  ninja,
  cudaPackages_12,
  cudaPackages_13,
  boost186,
  fmt_10,
  git,
  jsoncpp,
  libevent,
  lshw,
  plog,
  python3,
  replaceVars,
  symlinkJoin,
  tclap_1_4,
  util-linux,
  yaml-cpp,
}:
let
  # DCGM can depend on multiple versions of CUDA at the same time.
  # The runtime closure, thankfully, is quite small as it does not
  # include the CUDA libraries.
  cudaPackageSets = [
    cudaPackages_12
    cudaPackages_13
  ];

  # Select needed redist packages from cudaPackages
  # C.f. https://github.com/NVIDIA/DCGM/blob/7e1012302679e4bb7496483b32dcffb56e528c92/dcgmbuild/scripts/0080_cuda.sh#L24-L39
  getCudaPackages =
    p:
    with p;
    [
      cuda_cccl
      cuda_cudart
      cuda_nvcc
      cuda_nvml_dev
      libcublas
      libcufft
      libcurand
    ]
    ++ lib.optional (p.cudaMajorVersion >= "13") cuda_crt;

  # Builds CMake flags to add CUDA paths for include and lib.
  mkCudaFlags =
    cudaPackages:
    let
      version = cudaPackages.cudaMajorVersion;
      # Create a CMake list format (semicolon-separated, but properly quoted)
      includePaths = lib.concatMapStringsSep ";" (pkg: "${lib.getInclude pkg}/include") (
        getCudaPackages cudaPackages
      );
    in
    [
      (lib.cmakeFeature "CUDA${version}_INCLUDE_DIR" "${includePaths}")
      (lib.cmakeFeature "CUDA${version}_LIBS" "${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs/libcuda.so")
      (lib.cmakeFeature "CUDA${version}_STATIC_LIBS" "${lib.getLib cudaPackages.cuda_cudart}/lib/libcudart.so")
      (lib.cmakeFeature "CUDA${version}_STATIC_CUBLAS_LIBS" (
        lib.concatStringsSep ";" [
          "${lib.getLib cudaPackages.libcublas}/lib/libcublas.so"
          "${lib.getLib cudaPackages.libcublas}/lib/libcublasLt.so"
        ]
      ))
    ];
in
stdenv.mkDerivation rec {
  pname = "dcgm";
  version = "4.4.2"; # N.B: If you change this, be sure prometheus-dcgm-exporter supports this version.

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "DCGM";
    # No tag for 4.3.1 yet.
    tag = "v${version}";
    hash = "sha256-md13fDtTGFmxCBK/Or4PvZ7MmBTO0TFHF3Z/KpBAsrs=";
  };

  patches = [
    ./remove-cuda-11.patch
    ./dynamic-libs.patch
    ./fix-cublas-includes.patch
    (replaceVars ./fix-paths.patch {
      inherit coreutils;
      inherit util-linux;
      inherit lshw;
      inherit (stdenv) shell;
      dcgm_out = null;
    })
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
    boost186
    catch2_3
    plog.dev
    tclap_1_4

    fmt_10
    yaml-cpp
    jsoncpp
    libevent
  ];

  nativeCheckInputs = [
    mpi
    ctestCheckHook
    mpiCheckPhaseHook
  ];

  disabledTests = [
    # Fail due to lack of `/sys` in the sandbox.
    "DcgmModuleSysmon::PauseResume Module resumed after initialization"
    "DcgmModuleSysmon PauseResume Module rejects invalid messages"
    "DcgmModuleSysmon PauseResume Module accepts valid messages"
    "DcgmModuleSysmon Watches"
    "DcgmModuleSysmon maxSampleAge"
    "DcgmModuleSysmon::CalculateCoreUtilization"
    "DcgmModuleSysmon::ParseProcStatCpuLine"
    "DcgmModuleSysmon::ParseThermalFileContentsAndStore"
    "DcgmModuleSysmon::PopulateTemperatureFileMap"
    "DcgmModuleSysmon::ReadCoreSpeed"
    "DcgmModuleSysmon::ReadTemperature"
    "Sysmon: initialize module"

    # Fail due to missing plugin directory in sandbox
    "Scenario: GetPluginCudalessDir returns cudaless directory in plugin directory"
  ];

  # Add our paths to the CMake flags so FindCuda.cmake can find them.
  cmakeFlags = lib.concatMap mkCudaFlags cudaPackageSets ++ [
    "-DCMAKE_CXX_FLAGS=-D_GNU_SOURCE"
  ];

  # Lots of dodgy C++.
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  doCheck = true;
  dontUseNinjaCheck = true;

  postPatch = ''
    # Fix gettid.h to include unistd.h unconditionally
    sed -i '/#pragma once/a #include <unistd.h>' common/gettid.h

    # Fix jsoncpp_static references to use dynamic library
    find . -name "CMakeLists.txt" -exec sed -i 's/jsoncpp_static/jsoncpp/g' {} +

    # Remove all the problematic test install commands from mndiag
    # These create symlinks and directories that aren't needed in Nix
    sed -i '/^install(CODE "$/,/^    COMPONENT Tests)$/d' modules/mndiag/CMakeLists.txt

    while read -r -d "" file; do
      substituteInPlace "$file" --replace-quiet @dcgm_out@ "$out"
    done < <(find . '(' -name '*.h' -or -name '*.cpp' ')' -print0)
  '';

  disallowedReferences = lib.concatMap getCudaPackages cudaPackageSets;

  __structuredAttrs = true;

  meta = {
    description = "Data Center GPU Manager (DCGM) is a daemon that allows users to monitor NVIDIA data-center GPUs";
    homepage = "https://developer.nvidia.com/dcgm";
    license = lib.licenses.asl20;
    teams = [ lib.teams.deshaw ];
    mainProgram = "dcgmi";
    platforms = lib.platforms.linux;
  };
}
