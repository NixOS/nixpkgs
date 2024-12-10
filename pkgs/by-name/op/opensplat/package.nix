{
  lib,
  stdenv,
  cmake,
  ninja,
  fetchFromGitHub,
  fetchpatch,
  python3,
  opencv,
  nlohmann_json,
  nanoflann,
  glm,
  cxxopts,
  config,
  # Upstream has rocm/hip support, too. anyone?
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  autoAddDriverRunpath,
}:
let
  version = "1.1.2";
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
    rev = "refs/tags/v${version}";
    hash = "sha256-3tk62b5fSf6wzuc5TwkdfAKgUMrw3ZxetCJa2RVMS/s=";
  };

  patches = [
    (fetchpatch {
      name = "install-executables.patch";
      url = "https://github.com/pierotofy/OpenSplat/commit/b4c4176819b508978583b7ebf66306171807a8e6.patch";
      hash = "sha256-BUgPMcO3lt3ZEzv24u36k3aTEIoloOhxrCGi1KQ5Epk=";
    })
  ];

  postPatch = ''
    # the two vendored gsplats are so heavily modified they may be considered a fork
    find vendor ! -name 'gsplat*' -maxdepth 1 -mindepth 1 -exec rm -rf {} +
    mkdir vendor/{nanoflann,glm}
    ln -s ${glm}/include/glm vendor/glm/glm
    ln -s ${nanoflann}/include/nanoflann.hpp vendor/nanoflann/nanoflann.hpp
    ln -s ${nlohmann_json}/include/nlohmann vendor/json
    ln -s ${cxxopts}/include/cxxopts.hpp vendor/cxxopts.hpp
  '';

  nativeBuildInputs =
    [
      cmake
      ninja
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
      autoAddDriverRunpath
    ];

  buildInputs =
    [
      nlohmann_json
      torch.cxxdev
      torch
      opencv
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
    ];

  env.TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" python3.pkgs.torch.cudaCapabilities}";

  cmakeFlags =
    [
      (lib.cmakeBool "CMAKE_SKIP_RPATH" true)
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeFeature "GPU_RUNTIME" "CUDA")
      (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${cudaPackages.cudatoolkit}/")
    ];

  meta = {
    description = "Production-grade 3D gaussian splatting";
    homepage = "https://github.com/pierotofy/OpenSplat/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jcaesar ];
    platforms = lib.platforms.linux ++ lib.optionals (!cudaSupport) lib.platforms.darwin;
  };
}
