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

  folly,
  libsodium,
  zlib,

  gtest,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fizz";
  version = "2025.04.21.00";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fizz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-khaUbxcD8+9zznH0DE/BpweZeDKafTnr4EqPbmOpckU=";
  };

  patches = [
    ./glog-0.7.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    openssl
    glog
    double-conversion
    zstd
    gflags
    libevent
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

    (lib.cmakeFeature "BIN_INSTALL_DIR" "${placeholder "bin"}/bin")
    (lib.cmakeFeature "INCLUDE_INSTALL_DIR" "${placeholder "dev"}/include")
    (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "out"}/lib")
    (lib.cmakeFeature "CMAKE_INSTALL_DIR" "${placeholder "dev"}/lib/cmake/fizz")
    # Fizz puts test headers into `${CMAKE_INSTALL_PREFIX}/include`
    # for other projects to consume.
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "dev"))
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++14 implementation of the TLS-1.3 standard";
    homepage = "https://github.com/facebookincubator/fizz";
    changelog = "https://github.com/facebookincubator/fizz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pierreis
      kylesferrazza
      emily
      techknowlogick
    ];
  };
})
