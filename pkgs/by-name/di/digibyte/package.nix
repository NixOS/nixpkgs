{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  boost177,
  libevent,
  autoreconfHook,
  db4,
  pkg-config,
  protobuf,
  hexdump,
  zeromq,
  withGui ? true,
  libsForQt5,
}:

let
  boost = boost177;
in

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

  postPatch = ''
    sed -i '1i #include <deque>' src/httpserver.cpp
    sed -i '1i #include <stdexcept>' src/support/lockedpool.cpp
    sed -i '1i #include <QPainterPath>' src/qt/trafficgraphwidget.cpp

    sed -i -e 's/\b_1\b/boost::placeholders::_1/g' \
           -e 's/\b_2\b/boost::placeholders::_2/g' \
           -e 's/\b_3\b/boost::placeholders::_3/g' \
           -e 's/\b_4\b/boost::placeholders::_4/g' \
           -e 's/\b_5\b/boost::placeholders::_5/g' \
           src/qt/*.cpp src/qt/*.h
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ]
  ++ lib.optionals withGui [
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
  ]
  ++ lib.optionals withGui [
    libsForQt5.qtbase
    libsForQt5.qttools
    protobuf
  ];

  enableParallelBuilding = true;

  # Inject the Boost backward-compatibility flag directly into the C++ compiler
  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error -std=c++17";
  };

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-werror"
    "--disable-tests"
    "--disable-gui-tests"
    "--disable-bench"
  ]
  ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${libsForQt5.qtbase.dev}/bin:${libsForQt5.qttools.dev}/bin"
  ];

  meta = {
    description = "DigiByte (DGB) is a rapidly growing decentralized, global blockchain";
    homepage = "https://digibyte.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
  };
})
