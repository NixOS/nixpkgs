{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  python3,
  gtest,
  withAnimation ? true,
  withTranscoder ? true,
  eigen,
  ghc_filesystem,
  tinygltf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "draco";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    rev = finalAttrs.version;
    hash = "sha256-Y1bwBFe3bCklZN2+TBs6mhqDKQjrezMiT5zXlPFuMew=";
  };

  # ld: unknown option: --start-group
  postPatch = lib.optional stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/draco_targets.cmake \
      --replace "^Clang" "^AppleClang"
  '';

  nativeBuildInputs = [
    cmake
    python3
    gtest
  ];

  buildInputs = lib.optionals withTranscoder [
    eigen
    ghc_filesystem
    tinygltf
  ];

  cmakeFlags = [
    (lib.cmakeFeature "DRACO_GOOGLETEST_PATH" (builtins.toString gtest))
    (lib.cmakeBool "DRACO_ANIMATION_ENCODING" withAnimation)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "DRACO_TRANSCODER_SUPPORTED" withTranscoder)
  ]
  ++ lib.optionals withTranscoder [
    "-DDRACO_EIGEN_PATH=${eigen}/include/eigen3"
    "-DDRACO_FILESYSTEM_PATH=${ghc_filesystem}"
    "-DDRACO_TINYGLTF_PATH=${tinygltf}"
  ];

  CXXFLAGS = [
    # error: expected ')' before 'value' in 'explicit GltfValue(uint8_t value)'
    "-include cstdint"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for compressing and decompressing 3D geometric meshes and point clouds";
    homepage = "https://google.github.io/draco/";
    changelog = "https://github.com/google/draco/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jansol ];
    platforms = lib.platforms.all;
  };
})
