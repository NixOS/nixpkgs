{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  boost,
  libevent,
  autoreconfHook,
  db4,
  miniupnpc,
  sqlite,
  pkg-config,
  util-linux,
  hexdump,
  zeromq,
  zlib,
  darwin,
  withWallet ? true,
}:

stdenv.mkDerivation rec {
  pname = "namecoind";
  version = "28.0";

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    tag = "nc${version}";
    hash = "sha256-r6rVgPrKz7nZ07oXw7KmVhGF4jVn6L+R9YHded+3E9k=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ util-linux ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ hexdump ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    boost
    libevent
    db4
    miniupnpc
    zeromq
    zlib
  ]
  ++ lib.optionals withWallet [ sqlite ]
  # building with db48 (for legacy descriptor wallet support) is broken on Darwin
  ++ lib.optionals (withWallet && !stdenv.hostPlatform.isDarwin) [ db4 ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-bench"
    "--disable-gui-tests"
  ]
  ++ lib.optionals (!withWallet) [
    "--disable-wallet"
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkFlags = [ "LC_ALL=en_US.UTF-8" ];

  meta = with lib; {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = "https://namecoin.org";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
