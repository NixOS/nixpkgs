{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  boost,
  libevent,
  autoreconfHook,
  db4,
  pkg-config,
  protobuf,
  hexdump,
  zeromq,
  withGui,
  qtbase ? null,
  qttools ? null,
  wrapQtAppsHook ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "digibyte";
  version = "7.17.3";

  name = finalAttrs.pname + toString (lib.optional (!withGui) "d") + "-" + finalAttrs.version;

  src = fetchFromGitHub {
    owner = "digibyte-core";
    repo = "digibyte";
    rev = "v${finalAttrs.version}";
    sha256 = "zPwnC2qd28fA1saG4nysPlKU1nnXhfuSG3DpCY6T+kM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ]
  ++ lib.optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
  ]
  ++ lib.optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
  ]
  ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  meta = {
    description = "DigiByte (DGB) is a rapidly growing decentralized, global blockchain";
    homepage = "https://digibyte.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
  };
})
