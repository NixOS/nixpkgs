{ lib, stdenv
, fetchFromGitHub
, openssl
, boost
, libb2
, libevent
, autoreconfHook
, db4
, pkg-config
, protobuf
, hexdump
, zeromq
, libsodium
, withGui
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
}:

with lib;

stdenv.mkDerivation rec {

  pname = "bitcoin" + toString (optional (!withGui) "d") + "-gold";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "BTCGPU";
    repo = "BTCGPU";
    rev = "v${version}";
    sha256 = "sha256-1tFoUNsCPJkHSmNRl5gE3n2EQD6RZSry1zIM5hiTzEI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ] ++ optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
    libsodium
    libb2
  ] ++ optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
  ] ++ optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  meta = {
    description = "BTG is a cryptocurrency with Bitcoin fundamentals, mined on common GPUs instead of specialty ASICs";
    homepage = "https://bitcoingold.org/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
