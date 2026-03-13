{
  stdenv,
  config,
  lib,
  cmake,
  eigen,
  cpuinfo,
  fp16,
  zlib,
  numactl,
  mpich,
  fmt,
  openssl_oqs,
  autoPatchelfHook,
  removeReferencesTo,
  opentelemetry-cpp,
  gbenchmark,
  python3,
  python3Packages,
  protobuf,
  fetchFromGitHub,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  cudaPackages,
}:
let

  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  pythonEnv = python3.withPackages (ps: [
    ps.pybind11
    ps.setuptools

    ps.six # dependency chain: NNPACK -> PeachPy -> six
    ps.typing-extensions
    ps.pyyaml
  ]);
  setBool = v: if v then "1" else "0";
in
effectiveStdenv.mkDerivation rec {
  name = "libtorch";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "pytorch";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Jszhe67FteiSbkbUEjVIkWVUjUY8IS5qVHct4HvcfIg=";
  };

  patches = [
    # The CMake install tries to add some hardcoded rpaths, incompatible
    # with the Nix store, which fails. Simply remove this step to get
    # rpaths that point to the Nix store.
    ./disable-cmake-mkl-rpath.patch
  ];

  nativeBuildInputs = [
    cmake
    autoPatchelfHook
    removeReferencesTo
  ];
  buildInputs = [
    eigen
    cpuinfo
    fp16
    zlib
    numactl
    fmt
    mpich
    openssl_oqs
    opentelemetry-cpp
    gbenchmark
    protobuf
    pythonEnv
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cudatoolkit
      #cudaPackages.libcudss
      nccl

      cudnn
      cuda_cccl # <thrust/*>
      cuda_cudart # cuda_runtime.h and libraries
      cuda_cupti # For kineto
      cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildInputs, it's needed here too
      cuda_nvml_dev # <nvml.h>
      cuda_nvrtc
      cuda_nvtx # -llibNVToolsExt
      libcublas
      libcufft
      libcufile
      libcurand
      libcusolver
      libcusparse
      libcusparse_lt
    ]
  )
  ++ lib.optionals rocmSupport [
  ];

  propagateBuildInputs = [
    fmt
    protobuf
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  USE_MKLDNN = setBool true;
  USE_MKLDNN_CBLAS = setBool true;

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    # file RPATH_CHANGE could not write new RPATH
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (lib.cmakeBool "USE_CUDA" cudaSupport)
    (lib.cmakeBool "DBUILD_SHARED_LIBS" true)
    (lib.cmakeBool "BUILD_PYTHON" false)
    (lib.cmakeBool "USE_SYSTEM_CPUINFO" true)
    (lib.cmakeBool "USE_SYSTEM_EIGEN_INSTALL" true)
    (lib.cmakeBool "USE_SYSTEM_FP16" true)
    (lib.cmakeBool "USE_SYSTEM_PYBIND11" true)
    (lib.cmakeBool "BUILD_CUSTOM_PROTOBUF" false)
    (lib.cmakeOptionType "path" "PYTHON_SIX_SOURCE_DIR"
      "${python3Packages.six}/${python3.sitePackages}/six"
    )
    (lib.cmakeOptionType "path" "PYTHON_EXECUTABLE" "${pythonEnv}/bin/python3")
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeBool "USE_SYSTEM_NCCL" true)
  ]
  ++ lib.optionals rocmSupport [
  ];

  meta = with lib; {
    description = "C++ API of the PyTorch machine learning framework";
    homepage = "https://pytorch.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [
      pfmephisto
      junjihashimoto
    ];
    platforms = [
      #"aarch64-darwin"
      "x86_64-linux"
    ];
  };
}
