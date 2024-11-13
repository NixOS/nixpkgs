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
  mvfst,
  apple-sdk_11,
  darwinMinVersionHook,
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
      mvfst
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

      (lib.cmakeBool "thriftpy" false)
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
