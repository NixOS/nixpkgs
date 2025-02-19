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

stdenv.mkDerivation rec {
  pname = "digibyte";
  version = "7.17.3";

  name = pname + toString (lib.optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = "digibyte-core";
    repo = pname;
    rev = "v${version}";
    sha256 = "zPwnC2qd28fA1saG4nysPlKU1nnXhfuSG3DpCY6T+kM=";
  };

  nativeBuildInputs =
    [
      autoreconfHook
      pkg-config
      hexdump
    ]
    ++ lib.optionals withGui [
      wrapQtAppsHook
    ];

  buildInputs =
    [
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

  configureFlags =
    [
      "--with-boost-libdir=${boost.out}/lib"
    ]
    ++ lib.optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
    ];

  meta = with lib; {
    description = "DigiByte (DGB) is a rapidly growing decentralized, global blockchain";
    homepage = "https://digibyte.io/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
