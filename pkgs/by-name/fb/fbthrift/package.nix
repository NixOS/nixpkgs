{
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  libevent,
  double-conversion,
  fizz,
  flex,
  folly,
  glog,
  gflags,
  libiberty,
  mvfst,
  openssl,
  lib,
  wangle,
  zlib,
  zstd,
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbthrift";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fbthrift";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-iCiiKNDlfKm1Y4SGzcSP6o/OdiRRrj9UEawW6qpBpSY=";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isDarwin then "OFF" else "ON"}"
  ];

  buildInputs =
    [
      double-conversion
      fizz
      folly
      glog
      gflags
      libevent
      libiberty
      mvfst
      openssl
      wangle
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  meta = with lib; {
    description = "Facebook's branch of Apache Thrift";
    mainProgram = "thrift1";
    homepage = "https://github.com/facebook/fbthrift";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      pierreis
      kylesferrazza
    ];
  };
})
