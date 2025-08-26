{
  config,
  autoPatchelfHook,
  boost,
  bzip2,
  cereal,
  cmake,
  eigen,
  extra-cmake-modules,
  fetchFromGitLab,
  fmt,
  freeglut,
  glew,
  lib,
  libepoxy,
  libGL,
  lz4,
  magic-enum,
  nix-update-script,
  opencv,
  pkg-config,
  stdenv,
  tbb,
  xorg,
  cudaPackages,
  enableCuda ? config.cudaSupport,
}:
stdenv.mkDerivation {
  pname = "basalt-monado";
  version = "0-unstable-2024-06-21";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mateosss";
    repo = "basalt";
    rev = "385c161f35720df3a6c606054565f9d49a1c5787";
    hash = "sha256-+2/pc2OWDwE04xPcfHL5GGyhQ1ZTN6o7cCNAilDgd2Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    boost
    bzip2
    cereal
    eigen
    fmt
    freeglut
    glew
    libepoxy
    libGL
    lz4
    magic-enum
    opencv.cxxdev
    tbb
    xorg.libX11
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
  ];

  cmakeFlags = [
    (lib.cmakeBool "BASALT_INSTANTIATIONS_DOUBLE" false)
    (lib.cmakeBool "BUILD_TESTS" false)
    (lib.cmakeFeature "EIGEN_ROOT" "${eigen}/include/eigen3")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fork of Basalt improved for tracking XR devices with Monado";
    homepage = "https://gitlab.freedesktop.org/mateosss/basalt";
    license = lib.licenses.bsd3;
    mainProgram = "basalt_vio";
    maintainers = [ lib.maintainers.locochoco ];
    platforms = lib.platforms.linux;
  };
}
