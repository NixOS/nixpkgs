{
  addDriverRunpath,
  cmake,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  fetchFromGitHub,
  git,
  glfw,
  lib,
  openexr,
  pkg-config,
  stdenv,
  unstableGitUpdater,
  zlib,
}:
let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  optix = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "optix-dev";
    tag = "v7.7.0";
    hash = "sha256-1sX4qgtIv/tO9+LQhTXES7Pmspk6yoiolCL/D9jvsTE=";
  };
in
stdenv'.mkDerivation {
  pname = "pbrt-v4";
  version = "0-unstable-2026-11-15";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mmp";
    repo = "pbrt-v4";
    rev = "20e41fd83789f12550e2c31b2047898c9e20e46c";
    fetchSubmodules = true;
    hash = "sha256-kel0NvRQbuWGYIzhx+KBMIyC44r4pDEpLnN3LOGUhzs=";
  };

  patches = [
    # use glfw in nixpkgs
    ./glfw.patch
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
      cccl
      cuda_cudart
    ]
  );

  cmakeFlags = lib.optionals cudaSupport [
    (lib.cmakeFeature "PBRT_OPTIX_PATH" "${optix}")
    (lib.cmakeFeature "PBRT_GPU_SHADER_MODEL" "${builtins.head cudaPackages.flags.realArches}")
  ];

  # link -lcuda against the stub, the real one is found via addDriverRunpath at runtime
  env.NIX_LDFLAGS = lib.optionalString cudaSupport "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs";

  postFixup = lib.optionalString cudaSupport ''
    addDriverRunpath $out/bin/pbrt
  '';

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Ray tracer described in the 4th edition of the 'Physically Based Rendering: From Theory to Implementation' book.";
    homepage = "github.com/mmp/pbrt-v4";
    mainProgram = "pbrt";
    license = with lib.licenses; [ asl20 ] ++ lib.optional cudaSupport nvidiaCudaRedist;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ lib.maintainers.tsssni ];
  };
}
