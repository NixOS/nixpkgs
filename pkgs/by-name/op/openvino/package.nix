{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  cudaSupport ? opencv.cudaSupport or false,

  # build
  scons,
  addDriverRunpath,
  autoPatchelfHook,
  cmake,
  git,
  libarchive,
  patchelf,
  pkg-config,
  python3Packages,
  shellcheck,

  # runtime
  flatbuffers,
  gflags,
  level-zero,
  libusb1,
  libxml2,
  ocl-icd,
  opencv,
  protobuf,
  pugixml,
  snappy,
  onetbb,
  cudaPackages,
}:

let
  inherit (lib)
    cmakeBool
    ;

  # prevent scons from leaking in the default python version
  scons' = scons.override { inherit python3Packages; };

  tbbbind_version = "2_5";
  tbbbind = fetchurl {
    url = "https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/tbbbind_${tbbbind_version}_static_lin_v4.tgz";
    hash = "sha256-Tr8wJGUweV8Gb7lhbmcHxrF756ZdKdNRi1eKdp3VTuo=";
  };

  python = python3Packages.python.withPackages (
    ps: with ps; [
      cython
      distutils
      pybind11
      setuptools
      sphinx
      wheel
    ]
  );

in

stdenv.mkDerivation rec {
  pname = "openvino";
  version = "2025.2.0";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "openvino";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-EtXHMOIk4hGcLiaoC0ZWYF6XZCD2qNtt1HeJoJIuuTA=";
  };

  patches = [
    (fetchpatch {
      name = "cmake4-compat.patch";
      url = "https://github.com/openvinotoolkit/openvino/commit/677716c2471cadf1bf1268eca6343498a886a229.patch?full_index=1";
      hash = "sha256-iaifJBdl7+tQZq1d8SiczUaXz+AdfMrLtwzfTmSG+XA=";
    })
  ];

  outputs = [
    "out"
    "python"
  ];

  nativeBuildInputs = [
    addDriverRunpath
    autoPatchelfHook
    cmake
    git
    libarchive
    patchelf
    pkg-config
    python
    scons'
    shellcheck
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  postPatch = ''
    mkdir -p temp/tbbbind_${tbbbind_version}
    pushd temp/tbbbind_${tbbbind_version}
    bsdtar -xf ${tbbbind}
    echo "${tbbbind.url}" > ie_dependency.info
    popd
  '';

  dontUseSconsCheck = true;
  dontUseSconsBuild = true;
  dontUseSconsInstall = true;

  cmakeFlags = [
    "-Wno-dev"
    "-DCMAKE_MODULE_PATH:PATH=${placeholder "out"}/lib/cmake"
    "-DCMAKE_PREFIX_PATH:PATH=${placeholder "out"}"
    "-DOpenCV_DIR=${lib.getLib opencv}/lib/cmake/opencv4/"
    "-DProtobuf_LIBRARIES=${protobuf}/lib/libprotobuf${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DPython_EXECUTABLE=${python.interpreter}"

    (cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (cmakeBool "NCC_SYLE" false)
    (cmakeBool "BUILD_TESTING" false)
    (cmakeBool "ENABLE_CPPLINT" false)
    (cmakeBool "ENABLE_TESTING" false)
    (cmakeBool "ENABLE_SAMPLES" false)

    # features
    (cmakeBool "ENABLE_INTEL_CPU" stdenv.hostPlatform.isx86_64)
    (cmakeBool "ENABLE_INTEL_GPU" true)
    (cmakeBool "ENABLE_INTEL_NPU" stdenv.hostPlatform.isx86_64)
    (cmakeBool "ENABLE_JS" false)
    (cmakeBool "ENABLE_LTO" true)
    (cmakeBool "ENABLE_ONEDNN_FOR_GPU" false)
    (cmakeBool "ENABLE_OPENCV" true)
    (cmakeBool "ENABLE_OV_JAX_FRONTEND" false) # auto-patchelf could not satisfy dependency libopenvino_jax_frontend.so.2450
    (cmakeBool "ENABLE_PYTHON" true)

    # system libs
    (cmakeBool "ENABLE_SYSTEM_FLATBUFFERS" true)
    (cmakeBool "ENABLE_SYSTEM_OPENCL" true)
    (cmakeBool "ENABLE_SYSTEM_PROTOBUF" false)
    (cmakeBool "ENABLE_SYSTEM_PUGIXML" true)
    (cmakeBool "ENABLE_SYSTEM_SNAPPY" true)
    (cmakeBool "ENABLE_SYSTEM_TBB" true)
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libngraph_backend.so"
  ];

  # src/graph/src/plugins/intel_gpu/src/graph/include/reorder_inst.h:24:8: error: type 'struct typed_program_node' violates the C++ One Definition Rule [-Werror=odr]
  env.NIX_CFLAGS_COMPILE = "-Wno-odr";

  buildInputs = [
    flatbuffers
    gflags
    level-zero
    libusb1
    libxml2
    ocl-icd
    opencv
    pugixml
    snappy
    onetbb
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $python
    mv $out/python/* $python/
    rmdir $out/python
  '';

  postFixup = ''
    # Link to OpenCL
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addDriverRunpath "$lib"
    done
  '';

  meta = with lib; {
    changelog = "https://github.com/openvinotoolkit/openvino/releases/tag/${src.tag}";
    description = "Open-source toolkit for optimizing and deploying AI inference";
    longDescription = ''
      This toolkit allows developers to deploy pre-trained deep learning models through a high-level C++ Inference Engine API integrated with application logic.

      This open source version includes several components: namely Model Optimizer, nGraph and Inference Engine, as well as CPU, GPU, MYRIAD,
      multi device and heterogeneous plugins to accelerate deep learning inferencing on Intel® CPUs and Intel® Processor Graphics.
      It supports pre-trained models from the Open Model Zoo, along with 100+ open source and public models in popular formats such as Caffe*, TensorFlow*, MXNet* and ONNX*.
    '';
    homepage = "https://docs.openvinotoolkit.org/";
    license = with licenses; [ asl20 ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # Cannot find macos sdk
  };
}
