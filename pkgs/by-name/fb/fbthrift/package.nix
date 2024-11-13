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

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isDarwin then "OFF" else "ON"}"

    (lib.cmakeBool "thriftpy" false)
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
