{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,

  openssl,
  glog,
  double-conversion,
  zstd,
  gflags,
  libevent,
  apple-sdk_11,
  darwinMinVersionHook,

  folly,
  libsodium,
  zlib,

  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fizz";
  version = "2024.11.18.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fizz";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-mNe+CHEXhkwzek9qy2l6zvPXim9tJV44s+naSm6bQ4Q=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs =
    [
      openssl
      glog
      double-conversion
      zstd
      gflags
      libevent
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  propagatedBuildInputs = [
    folly
    libsodium
    zlib
  ];

  checkInputs = [
    gtest
  ];

  cmakeDir = "../fizz";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  preCheck =
    let
      disabledTests = [
        # timing-related & flaky
        "SlidingBloomReplayCacheTest.TestTimeBucketing"
      ];
    in
    ''
      export GTEST_FILTER="-${lib.concatStringsSep ":" disabledTests}"
    '';

  meta = {
    description = "C++14 implementation of the TLS-1.3 standard";
    homepage = "https://github.com/facebookincubator/fizz";
    changelog = "https://github.com/facebookincubator/fizz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pierreis
      kylesferrazza
    ];
  };
})
