{
  lib,
  stdenv,

  fetchFromGitHub,

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
  apple-sdk_11,
  darwinMinVersionHook,

  mvfst,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbthrift";
  version = "2024.11.18.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fbthrift";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-dJf4vaIcat24WiKLFNEqeCnJYiO+c5YkuFu+hrS6cPE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs =
    [
      openssl
      gflags
      glog
      folly
      fizz
      wangle
      zlib
      zstd
      xxHash
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  propagatedBuildInputs = [
    mvfst
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

      (lib.cmakeBool "thriftpy" false)

      # TODO: Can’t figure out where the C++ tests are wired up in the
      # CMake build, if anywhere, and this requires Python.
      #(lib.cmakeBool "enable_tests" finalAttrs.finalPackage.doCheck)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Homebrew sets this, and the shared library build fails without
      # it. I don‘t know, either. It scares me.
      (lib.cmakeFeature "CMAKE_SHARED_LINKER_FLAGS" "-Wl,-undefined,dynamic_lookup")
    ];

  meta = {
    description = "Facebook's branch of Apache Thrift";
    mainProgram = "thrift1";
    homepage = "https://github.com/facebook/fbthrift";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pierreis
      kylesferrazza
    ];
  };
})
