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
  onetbb,
  xorg,
  cudaPackages,
  enableCuda ? config.cudaSupport,
}:
stdenv.mkDerivation {
  pname = "basalt-monado";
  version = "0-unstable-2025-09-25";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mateosss";
    repo = "basalt";
    rev = "5337898271f5c2ce523258e93e80fd870130be31";
    hash = "sha256-IoXZlXyOc5y9aSHBU3WCNhHi4L9xzHmbv6VMEvX2ZeE=";
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
    onetbb
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
