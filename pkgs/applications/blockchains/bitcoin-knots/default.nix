{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, util-linux
, hexdump
, autoSignDarwinBinariesHook
, wrapQtAppsHook ? null
, boost
, libevent
, miniupnpc
, zeromq
, zlib
, db48
, sqlite
, qrencode
, qtbase ? null
, qttools ? null
, python3
, nixosTests
, withGui
, withWallet ? true
}:

stdenv.mkDerivation rec {
  pname = if withGui then "bitcoin-knots" else "bitcoind-knots";
  version = "23.0.knots20220529";

  src = fetchurl {
    url = "https://bitcoinknots.org/files/23.x/${version}/bitcoin-${version}.tar.gz";
    sha256 = "0c6l4bvj4ck8gp5vm4dla3l32swsp6ijk12fyf330wgry4mhqxyi";
  };

  nativeBuildInputs =
    [ autoreconfHook pkg-config ]
    ++ lib.optionals stdenv.isLinux [ util-linux ]
    ++ lib.optionals stdenv.isDarwin [ hexdump ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ]
    ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs = [ boost libevent miniupnpc zeromq zlib ]
    ++ lib.optionals withWallet [ db48 sqlite ]
    ++ lib.optionals withGui [ qrencode qtbase qttools ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-bench"
  ] ++ lib.optionals (!doCheck) [
    "--disable-tests"
    "--disable-gui-tests"
  ] ++ lib.optionals (!withWallet) [
    "--disable-wallet"
  ] ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  checkInputs = [ python3 ];

  doCheck = true;

  checkFlags =
    [ "LC_ALL=en_US.UTF-8" ]
    # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
    # See also https://github.com/NixOS/nixpkgs/issues/24256
    ++ lib.optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  passthru.tests = {
    smoke-test = nixosTests.bitcoind-knots;
  };

  meta = with lib; {
    description = "A derivative of Bitcoin Core with a collection of improvements";
    homepage = "https://bitcoinknots.org/";
    maintainers = with maintainers; [ prusnak mmahut ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
