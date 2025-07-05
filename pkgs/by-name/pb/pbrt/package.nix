{
  addDriverRunpath,
  cmake,
  cudaPackages,
  cudaSupport ? false,
  fetchzip,
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
  optix = fetchzip {
    url = "https://developer.download.nvidia.com/redist/optix/v7.4/OptiX-7.4.0-Include.zip";
    hash = "sha256-ksqtjnfouvP99VS9249cMngvAj8HlOxtqowRHIZ4E4Q=";
    stripRoot = false;
  };
in
stdenv'.mkDerivation {
  pname = "pbrt-v4";
  version = "2025-03-23";

  src = fetchFromGitHub {
    owner = "mmp";
    repo = "pbrt-v4";
    rev = "f140d7c";
    fetchSubmodules = true;
    sha256 = "sha256-xFKRoH3M4O1sUGtZCWJBL7MiXQGEBw1sk5N0NMzgasM=";
  };

  patches = [
    # use glfw in nixpkgs
    ./glfw.patch
    # https://github.com/mmp/pbrt-v4/issues/429
    ./cuda-atomic.patch
  ];

  nativeBuildInputs =
    [
      cmake
      git
      pkg-config
    ]
    ++ lib.optionals cudaSupport [
      addDriverRunpath
      cudaPackages.cuda_nvcc
    ];

  buildInputs =
    [
      glfw
      openexr
      zlib
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cccl
      cudaPackages.cuda_cudart
    ];

  cmakeFlags =
    [
      "-DBUILD_TESTING=ON"
    ]
    ++ lib.optionals cudaSupport [
      "-DPBRT_OPTIX7_PATH=${optix}"
      # manually specifty shading model with max compatibility to avoid runtime detection
      "-DPBRT_GPU_SHADER_MODEL=sm_75"
    ];

  postFixup = lib.optionalString cudaSupport ''
    addDriverRunpath $out/bin/pbrt
  '';

  meta = {
    description = "Source code to pbrt, the ray tracer described in the forthcoming 4th edition of the \"Physically Based Rendering: From Theory to Implementation\" book.";
    homepage = "github.com/mmp/pbrt-v4";
    mainProgram = "pbrt";
    license =
      with lib.licenses;
      [ asl20 ] ++ lib.optional cudaSupport (unfree // { shortName = "NVidia OptiX EULA"; });
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ lib.maintainers.tsssni ];
  };
}
