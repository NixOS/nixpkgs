{
  backendStdenv,
  boost,
  cmake,
  cuda_cudart,
  cuda_culibos ? null,
  cuda_nvcc,
  cudaAtLeast,
  cudaNamePrefix,
  fetchFromGitHub,
  flags,
  gitUpdater,
  lib,
  libjpeg_turbo,
  libnvjpeg,
  libnvjpeg_2k,
  libnvtiff,
  libtiff,
  ninja,
  nvtx,
  opencv4WithoutCuda,
  python3,
  zlib,
  zstd,
}:
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nvimgcodec";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvImageCodec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-25IlghY8r2ZyUSwptJrwFp+8WluLdZr6P3AgR5FY3xw=";
  };

  # Use the NVTX and Boost.Preprocessor headers of Nixpkgs instead of the submodules (external/NVTX and
  # external/boost/preprocessor), which aren't fetched. The DLPack submodule (external/dlpack) is used only by the Python
  # bindings, which aren't built.
  postPatch = ''
    substituteInPlace cmake/Dependencies.cmake \
      --replace-fail \
        "\''${PROJECT_SOURCE_DIR}/external/NVTX/c/include" \
        "${lib.getInclude nvtx}/include" \
      --replace-fail \
        "\''${PROJECT_SOURCE_DIR}/external/boost/preprocessor/include" \
        "${lib.getDev boost}/include"
  '';

  nativeBuildInputs = [
    cmake
    cuda_nvcc
    ninja
    # Generates the stubs for the CUDA driver API (loaded with dlopen) from cuda.h with libclang.
    (python3.pythonOnBuildForHost.withPackages (ps: [ ps.clang ]))
  ];

  buildInputs = [
    # Replaces the Boost.Preprocessor submodule (external/boost/preprocessor)
    boost
    cuda_cudart
    libjpeg_turbo
    libnvjpeg
    libnvjpeg_2k
    libnvtiff
    libtiff
    # Replaces the NVTX submodule (external/NVTX)
    nvtx
    # The OpenCV extension only uses the CPU codecs (imgcodecs).
    opencv4WithoutCuda
    zlib
    zstd
  ]
  # The nvJPEG and nvTIFF extensions link CUDA::culibos, a separate redistributable since CUDA 13.
  ++ lib.optionals (cudaAtLeast "13.0") [ cuda_culibos ];

  cmakeFlags = [
    (lib.cmakeFeature "CUDA_TARGET_ARCHS" flags.cmakeCudaArchitecturesString)
    # The directory of cuda.h, from which the stubs for the CUDA driver API are generated, is looked for only in the
    # CUDA toolkit include directories (cuda_nvcc and cccl).
    (lib.cmakeFeature "CUDA_MAIN_INCLUDE_DIR" "${lib.getOutput "include" cuda_cudart}/include")
    (lib.cmakeBool "BUILD_SAMPLES" false)
    (lib.cmakeBool "BUILD_TEST" false)
    (lib.cmakeBool "BUILD_PYTHON" false)

    # Link nvJPEG, nvJPEG2000 and nvTIFF instead of loading them with dlopen. The CUDA driver is still loaded with
    # dlopen (WITH_DYNAMIC_CUDA), so the library can be loaded on machines without a GPU.
    (lib.cmakeBool "WITH_DYNAMIC_NVJPEG" false)
    (lib.cmakeBool "WITH_DYNAMIC_NVJPEG2K" false)
    (lib.cmakeBool "WITH_DYNAMIC_NVTIFF" false)
    (lib.cmakeBool "WITH_SHARED_CUDA_LIBS" true)

    # Upstream defaults to lib64/libnvimgcodec/<CUDA major>; the extensions are looked up next to the library, in
    # <libdir>/extensions.
    (lib.cmakeFeature "NVIMGCODEC_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "NVIMGCODEC_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "NVIMGCODEC_INSTALL_EXTENSIONS_DIR" "lib/extensions")
    (lib.cmakeFeature "NVIMGCODEC_INSTALL_EXTENSION_LIBDIR" "lib/extensions")
    # Would install /etc/ld.so.conf.d/nvimgcodec-<CUDA major>.conf
    (lib.cmakeBool "NVIMGCODEC_INSTALL_LD_SO_CONF" false)
  ];

  passthru.updateScript = gitUpdater {
    inherit (finalAttrs) pname version;
    rev-prefix = "v";
  };

  meta = {
    description = "Library of GPU- and CPU-accelerated image codecs with a unified interface";
    homepage = "https://github.com/NVIDIA/nvImageCodec";
    changelog = "https://github.com/NVIDIA/nvImageCodec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
  };
})
