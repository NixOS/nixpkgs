{
  cmake,
  fetchFromGitHub,
  git,
  gitUpdater,
  fetchpatch,
  lib,
  nlohmann_json,
  pkg-config,
  python3,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lcevcdec";
  version = "4.0.2";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "v-novaltd";
    repo = "LCEVCdec";
    tag = finalAttrs.version;
    hash = "sha256-NbaU543M+xCF5OmMKwE6jK0F5USlpp/Jaw6g3qz+iN4=";
  };

  postPatch = ''
    substituteInPlace cmake/tools/version_files.py \
      --replace-fail "args.git_version" '"${finalAttrs.version}"' \
      --replace-fail "args.git_hash" '"${finalAttrs.src.rev}"' \
      --replace-fail "args.git_date" '"1970-01-01"'
  '';

  env = {
    includedir = "${placeholder "dev"}/include";
    libdir = "${placeholder "out"}/lib";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    python3
  ];

  buildInputs = [
    nlohmann_json
  ];

  cmakeFlags = [
    (lib.cmakeFeature "VN_SDK_FFMPEG_LIBS_PACKAGE" "")
    (lib.cmakeBool "VN_SDK_UNIT_TESTS" false)
    (lib.cmakeBool "VN_SDK_SAMPLE_SOURCE" false)
    (lib.cmakeBool "VN_SDK_JSON_CONFIG" true)
    (lib.cmakeBool "VN_CORE_AVX2" stdenv.hostPlatform.avx2Support)
    # Requires avx for checking on runtime
    (lib.cmakeBool "VN_CORE_SSE" stdenv.hostPlatform.avxSupport)
    (lib.cmakeBool "VN_SDK_SIMD" stdenv.hostPlatform.avxSupport)
  ];

  passthru = {
    updateScript = gitUpdater { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://github.com/v-novaltd/LCEVCdec";
    description = "MPEG-5 LCEVC Decoder";
    license = lib.licenses.bsd3Clear;
    pkgConfigModules = [ "lcevc_dec" ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
    # https://github.com/v-novaltd/LCEVCdec/blob/bf7e0d91c969502e90a925942510a1ca8088afec/cmake/modules/VNovaProject.cmake#L29
    platforms = lib.platforms.aarch ++ lib.platforms.x86;
  };
})
