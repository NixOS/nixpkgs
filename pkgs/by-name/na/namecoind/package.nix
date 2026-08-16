{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  boost,
  libevent,
  db4,
  miniupnpc,
  sqlite,
  pkg-config,
  cmake,
  ninja,
  util-linux,
  hexdump,
  zeromq,
  zlib,
  darwin,
  withWallet ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "namecoind";
  version = "31.1";

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    tag = "nc${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-FeFo8KqsJ/uP2IIIHlAU5IXibFiXtKAsfeDmO49wCH0=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ util-linux ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ hexdump ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    boost
    libevent
    miniupnpc
    zeromq
    zlib
  ]
  ++ lib.optionals withWallet [ sqlite ]
  ++ lib.optionals (withWallet && !stdenv.hostPlatform.isDarwin) [ db4 ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBOOST_ROOT=${boost.out}"
    "-DBUILD_BENCH=OFF"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_GUI=OFF"
    "-DENABLE_IPC=OFF"
  ]
  ++ lib.optionals (!withWallet) [
    "-DENABLE_WALLET=OFF"
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;
  checkFlags = [ "LC_ALL=en_US.UTF-8" ];

  meta = {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = "https://namecoin.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lukas-sgx ];
    platforms = lib.platforms.linux;
  };
})
