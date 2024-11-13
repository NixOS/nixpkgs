{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,

  folly,
  openssl,
  glog,
  double-conversion,
  zstd,
  libsodium,
  gflags,
  zlib,
  libevent,
  apple-sdk_11,
  darwinMinVersionHook,

  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fizz";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fizz";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-IHWotiVUjGOvebXy4rwsh8U8UMxTrF1VaqXzZMjojiM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs =
    [
      folly
      openssl
      glog
      double-conversion
      zstd
      libsodium
      gflags
      zlib
      libevent
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  checkInputs = [
    gtest
  ];

  cmakeDir = "../fizz";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  preCheck =
    let
      disabledTests = [
        # these don't work with openssl 3.x probably due to
        # https://github.com/openssl/openssl/issues/13283
        "DefaultCertificateVerifierTest.TestVerifySuccess"
        "DefaultCertificateVerifierTest.TestVerifyWithIntermediates"

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
