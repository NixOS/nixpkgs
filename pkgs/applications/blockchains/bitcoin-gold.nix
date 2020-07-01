{ stdenv
, fetchFromGitHub
, openssl
, boost
, libevent
, autoreconfHook
, db4
, pkgconfig
, protobuf
, hexdump
, zeromq
, libsodium
, withGui
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  
  pname = "bitcoin" + toString (optional (!withGui) "d") + "-gold";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "BTCGPU";
    repo = "BTCGPU";
    rev = "v${version}";
    sha256 = "0grd1cd8d2nsrxl27la85kcan09z73fn70ncr9km4iccaj5pg12h";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
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
