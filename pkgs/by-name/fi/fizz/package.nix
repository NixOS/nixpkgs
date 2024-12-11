{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,
  removeReferencesTo,

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

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fizz";
  version = "2024.11.18.00";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fizz";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-mNe+CHEXhkwzek9qy2l6zvPXim9tJV44s+naSm6bQ4Q=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    removeReferencesTo
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

  postFixup = ''
    # Sanitize header paths to avoid runtime dependencies leaking in
    # through `__FILE__`.
    (
      shopt -s globstar
      for header in "$dev/include"/**/*.h; do
        sed -i "1i#line 1 \"$header\"" "$header"
        remove-references-to -t "$dev" "$header"
      done
    )
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
