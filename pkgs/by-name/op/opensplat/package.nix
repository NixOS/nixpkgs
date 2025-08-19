{
  lib,
  stdenv,
  cmake,
  ninja,
  fetchFromGitHub,
  python3,
  opencv,
  nlohmann_json,
  nanoflann,
  glm,
  cxxopts,
  nix-update-script,
  config,
  # Upstream has rocm/hip support, too. anyone?
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  autoAddDriverRunpath,
  fetchpatch2,
}:
let
  version = "1.1.4";
  torch = python3.pkgs.torch.override { inherit cudaSupport; };
  # Using a normal stdenv with cuda torch gives
  # ld: /nix/store/k1l7y96gv0nc685cg7i3g43i4icmddzk-python3.11-torch-2.2.1-lib/lib/libc10.so: undefined reference to `std::ios_base_library_init()@GLIBCXX_3.4.32'
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
stdenv'.mkDerivation {
  pname = "opensplat";
  inherit version;

  src = fetchFromGitHub {
    owner = "pierotofy";
    repo = "OpenSplat";
    tag = "v${version}";
    hash = "sha256-u2UmD0O3sUWELYb4CjQE19i4HUjLMcaWqOinQH0PPTM=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/pierotofy/OpenSplat/commit/7fb96e86a43ac6cfd3eb3a7f6be190c5f2dbeb73.patch";
      hash = "sha256-hWJWU/n1pRAAbExAYUap6CoSjIu2dzCToUmacSSpa0I=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs = [
    nlohmann_json
    nanoflann
    glm
    cxxopts
    torch.cxxdev
    torch
    opencv
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ];

  env.TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" python3.pkgs.torch.cudaCapabilities}";

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_SKIP_RPATH" true)
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "GPU_RUNTIME" "CUDA")
    (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${cudaPackages.cudatoolkit}/")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Production-grade 3D gaussian splatting";
    homepage = "https://github.com/pierotofy/OpenSplat/";
    license = [
      # main
      lib.licenses.agpl3Only
      # vendored+modified gsplat
      lib.licenses.asl20
    ];
    maintainers = [ lib.maintainers.jcaesar ];
    platforms = lib.platforms.linux ++ lib.optionals (!cudaSupport) lib.platforms.darwin;
  };
}
