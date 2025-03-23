{
  cmake,
  copyPkgconfigItems,
  fetchFromGitHub,
  fmt,
  git,
  gitUpdater,
  gtest,
  lib,
  makePkgconfigItem,
  pkg-config,
  python3,
  range-v3,
  rapidjson,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lcevcdec";
  version = "3.3.5";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "v-novaltd";
    repo = "LCEVCdec";
    tag = finalAttrs.version;
    hash = "sha256-PcV31lLABv7SGzrD/+rR9j1Z9/uZrp1hFPdW0EZwOqc=";
  };

  postPatch =
    ''
      substituteInPlace cmake/tools/version_files.py \
        --replace-fail "args.git_version" '"${finalAttrs.version}"' \
        --replace-fail "args.git_hash" '"${finalAttrs.src.rev}"' \
        --replace-fail "args.git_date" '"1970-01-01"'

    ''
    + lib.optionalString (!stdenv.hostPlatform.avxSupport) ''
      substituteInPlace cmake/modules/Compiler/GNU.cmake \
        --replace-fail "-mavx" ""

       substituteInPlace src/core/decoder/src/common/simd.c \
        --replace-fail "((_xgetbv(kControlRegister) & kOSXSaveMask) == kOSXSaveMask)" "false"
    '';

  env = {
    includedir = "${placeholder "dev"}/include";
    libdir = "${placeholder "out"}/lib";
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-variable";
  };

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "lcevc_dec";
      inherit (finalAttrs) version;
      libs = [
        "-L${variables.libdir}"
        "-llcevc_dec_api"
      ];
      libsPrivate = [
        "-lpthread"
        "-llcevc_dec_core"
      ];
      cflags = [
        "-I${variables.includedir}"
      ];
      variables = {
        prefix = "@dev@";
        includedir = "@includedir@";
        libdir = "@libdir@";
      };
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
    git
    pkg-config
    copyPkgconfigItems
  ];

  buildInputs = [
    rapidjson
    fmt
    range-v3
  ];

  cmakeFlags = [
    (lib.cmakeFeature "VN_SDK_FFMPEG_LIBS_PACKAGE" "")
    (lib.cmakeBool "VN_SDK_UNIT_TESTS" false)
    (lib.cmakeBool "VN_SDK_SAMPLE_SOURCE" false)
    (lib.cmakeBool "VN_CORE_AVX2" stdenv.hostPlatform.avx2Support)
    # Requires avx for checking on runtime
    (lib.cmakeBool "VN_CORE_SSE" stdenv.hostPlatform.avxSupport)
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
    platforms = lib.platforms.all;
  };
})
