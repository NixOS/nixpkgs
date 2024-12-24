{
  cmake,
  copyPkgconfigItems,
  fetchFromGitHub,
  fetchpatch,
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
  version = "3.2.1";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "v-novaltd";
    repo = "LCEVCdec";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-Nf0YntB1A3AH0MTXlfUHhxYbzZqeB0EH9Fe9Xrqdsts=";
  };

  patches = [
    # fix for build with GCC 14
    (fetchpatch {
      url = "https://github.com/v-novaltd/LCEVCdec/commit/43ef5a17ec1ced77f834136945b3cbfe2e46b9b4.patch";
      hash = "sha256-8OgPh6v+nmRIUB6flR93qOjvaL8fUJdqIe48ZA+8Pr0=";
    })
  ];

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
