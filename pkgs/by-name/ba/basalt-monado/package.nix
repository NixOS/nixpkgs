{ stdenv,
  lib,
  boost,
  eigen,
  tbb_2021_8,
  fmt,
  bzip2,
  opengv,
  cli11,
  magic-enum,
  sophus,
  cereal_1_3_2,
  freeglut,
  glew,
  libGL,
  opencv,
  pangolin,
  fetchFromGitLab,
  fetchFromGitHub,
  cmake,
  pkg-config,
  autoPatchelfHook,
  extra-cmake-modules,
  nix-update-script
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "basalt";
  version = "release-673cc5c6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mateosss";
    repo = "basalt";
    rev = finalAttrs.version;
    hash = "sha256-cj4R6QtZ2yK8VEeNxu5KBNAQez6O0hsTc8CLdIxegyE=";
  };

  headers-src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mateosss";
    repo = "basalt-headers";
    rev = "28b09b3a5802d44835655778cdd9b1974569bd47";
    hash = "sha256-gCHCB/1hEy3R/MGexdbq3tIz30Ciw2QmmAqz5wjKhM0=";
  };

  postUnpack = ''
    rm -r source/thirdparty/basalt-headers
    ln -s ${finalAttrs.headers-src} source/thirdparty/basalt-headers
  '';

  patches = [
    ./fixed-cmakes.patch
    ./remove-ros.patch
    ./opengl-executables.patch
  ];

  pangolin_0_6 = pangolin.overrideAttrs ({
    version = "0.6";
    src = fetchFromGitHub {
      owner = "stevenlovegrove";
      repo = "Pangolin";
      rev = "86eb4975fc4fc8b5d92148c2e370045ae9bf9f5d";
      sha256 = "sha256-fKteOuOuGMWPZFxOUGCUcjeLXtTUXSGMSs1QfM5qblU=";
    };
    patches = [ ./pangolin-0_6-cstdint.patch ];
  });

  nativeBuildInputs = [
    cmake
    cli11
    extra-cmake-modules
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    boost
    eigen
    tbb_2021_8
    fmt
    bzip2
    opengv
    cli11
    magic-enum
    sophus
    cereal_1_3_2
    freeglut
    glew
    libGL
    (opencv.override{ enableGtk3 = true; })
    finalAttrs.pangolin_0_6
  ];

  cmakeFlags = [
    (lib.cmakeBool "BASALT_BUILTIN_CEREAL" false)
    (lib.cmakeBool "BASALT_BUILTIN_EIGEN" false)
    (lib.cmakeBool "BASALT_BUILTIN_SOPHUS" false)
    (lib.cmakeBool "BASALT_INSTANTIATIONS_DOUBLE" false)
    (lib.cmakeBool "BUILD_TESTS" false)
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A fork of Basalt improved for tracking XR devices with Monado";
    homepage = "https://gitlab.freedesktop.org/mateosss/basalt";
    license = lib.licenses.bsd3;
    mainProgram = "basalt_vio";
    maintainers = [ lib.maintainers.locochoco ];
    platforms = lib.platforms.all;
  };
})
