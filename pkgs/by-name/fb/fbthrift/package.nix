{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,

  cmake,
  ninja,

  openssl,
  gflags,
  glog,
  folly,
  fizz,
  wangle,
  zlib,
  zstd,
  xxHash,

  mvfst,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbthrift";
  version = "2025.04.21.00";

  outputs = [
    # Trying to split this up further into `bin`, `out`, and `dev`
    # causes issues with circular references due to the installed CMake
    # files referencing the path to the compiler.
    "out"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fbthrift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W86jBqq0wC8ZYcE7MQ76rV3axPf7efXieEot6ahonUI=";
  };

  patches = [
    # Remove a line that breaks the build due to the CMake classic of
    # incorrect path concatenation.
    ./remove-cmake-install-rpath.patch

    ./glog-0.7.patch

    # Backport upstream build system fixes. Remove on next update.
    (fetchpatch {
      url = "https://github.com/facebook/fbthrift/commit/638384afb83e5fae29a6483d20f9443b2342ca0b.patch";
      hash = "sha256-q0VgaQtwAEgDHZ6btOLSnKfkP2cXstFPxPNdX1wcdCg=";
    })
    (fetchpatch {
      url = "https://github.com/facebook/fbthrift/commit/350955beef40abec1e9d13112c9d2b7f95c29022.patch";
      hash = "sha256-SaCZ0iczj8He2wujWN08QpizsTsK6OhreroOHY9f0BA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    openssl
    gflags
    glog
    folly
    fizz
    wangle
    zlib
    zstd
  ];

  propagatedBuildInputs = [
    mvfst
    xxHash
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

    (lib.cmakeBool "thriftpy" false)

    # TODO: Can’t figure out where the C++ tests are wired up in the
    # CMake build, if anywhere, and this requires Python.
    #(lib.cmakeBool "enable_tests" finalAttrs.finalPackage.doCheck)

    (lib.cmakeFeature "BIN_INSTALL_DIR" "${placeholder "out"}/bin")
    (lib.cmakeFeature "INCLUDE_INSTALL_DIR" "${placeholder "out"}/include")
    (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "lib"}/lib")
    (lib.cmakeFeature "CMAKE_INSTALL_DIR" "${placeholder "out"}/lib/cmake/fbthrift")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Homebrew sets this, and the shared library build fails without
    # it. I don’t know, either. It scares me.
    (lib.cmakeFeature "CMAKE_SHARED_LINKER_FLAGS" "-Wl,-undefined,dynamic_lookup")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Facebook's branch of Apache Thrift";
    mainProgram = "thrift1";
    homepage = "https://github.com/facebook/fbthrift";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pierreis
      kylesferrazza
      emily
      techknowlogick
    ];
  };
})
