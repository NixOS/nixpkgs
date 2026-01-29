{
  addDriverRunpath,
  cmake,
  cudaPackages,
  cudaSupport ? false,
  fetchFromGitHub,
  git,
  glfw,
  lib,
  openexr,
  pkg-config,
  stdenv,
  zlib,
}:
let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  optix = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "optix-dev";
    tag = "v9.0.0";
    hash = "sha256-WbMKgiM1b3IZ9eguRzsJSkdZJR/SMQTda2jEqkeOwok=";
  };
in
stdenv'.mkDerivation {
  pname = "pbrt-v4";
  version = "2025-12-09";

  src = fetchFromGitHub {
    owner = "mmp";
    repo = "pbrt-v4";
    rev = "8c19f30";
    fetchSubmodules = true;
    sha256 = "sha256-WbMKgiM1b3IZ9eguRzsJSkdZJR/SMQTda2jEqkeOwok=";
  };

  patches = [
    # use glfw in nixpkgs
    ./glfw.patch
    # fix unmatched __CUDA_ARCH__ https://github.com/mmp/pbrt-v4/issues/429
    ./cuda-arch.patch
    # set libcuda.so path
    ./libcuda.patch
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ]
  ++ lib.optionals cudaSupport [
    addDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    glfw
    openexr
    zlib
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cccl
      cuda_cudart
    ]
  );

  cmakeFlags = lib.optionals cudaSupport [
    (lib.cmakeFeature "PBRT_OPTIX_PATH" "${optix}")
    (lib.cmakeFeature "PBRT_GPU_SHADER_MODEL" "${builtins.head cudaPackages.flags.realArches}")
    (lib.cmakeFeature "PBRT_CUDA_LIB" "${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs/libcuda.so")
  ];

  postFixup = lib.optionalString cudaSupport ''
    addDriverRunpath $out/bin/pbrt
  '';

  meta = {
    description = "Source code to pbrt, the ray tracer described in the forthcoming 4th edition of the \"Physically Based Rendering: From Theory to Implementation\" book.";
    homepage = "github.com/mmp/pbrt-v4";
    mainProgram = "pbrt";
    license = with lib.licenses; [ asl20 ] ++ lib.optional cudaSupport nvidiaCudaRedist;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ lib.maintainers.tsssni ];
  };
}
