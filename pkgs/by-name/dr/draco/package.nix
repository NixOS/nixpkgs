{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  python3,
  gtest,
  withAnimation ? true,
  withTranscoder ? true,
  eigen,
  ghc_filesystem,
}:

let
  # Inlined tinygltf v2.8.7. As discussed in #228937 and #239641, it is a
  # header-only library and upgrading it to 2.8.8 breaks the draco build.
  tinygltf = callPackage ./tinygltf.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "draco";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    rev = finalAttrs.version;
    hash = "sha256-p0Mn4kGeBBKL7Hoz4IBgb6Go6MdkgE7WZgxAnt1tE/0=";
    fetchSubmodules = true;
  };

  # ld: unknown option: --start-group
  postPatch = ''
    substituteInPlace cmake/draco_targets.cmake \
      --replace-fail "^Clang" "^AppleClang"
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    gtest
  ]
  ++ lib.optionals withTranscoder [
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
    (lib.cmakeFeature "DRACO_EIGEN_PATH" "${eigen}/include/eigen3")
    (lib.cmakeFeature "DRACO_FILESYSTEM_PATH" (builtins.toString ghc_filesystem))
    (lib.cmakeFeature "DRACO_TINYGLTF_PATH" (builtins.toString tinygltf))
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
