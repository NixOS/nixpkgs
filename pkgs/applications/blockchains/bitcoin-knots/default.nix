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
  version = "26.1.knots20240325";

  src = fetchurl {
    url = "https://bitcoinknots.org/files/26.x/${version}/bitcoin-${version}.tar.gz";
    hash = "sha256-PqpePDna2gpCzF2K43N4h6cV5Y9w/e5ZcUvaNEaFaIk=";
  };

  nativeBuildInputs =
    [ autoreconfHook pkg-config ]
    ++ lib.optionals stdenv.isLinux [ util-linux ]
    ++ lib.optionals stdenv.isDarwin [ hexdump ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ]
    ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs = [ boost libevent miniupnpc zeromq zlib ]
    ++ lib.optionals withWallet [ sqlite ]
    ++ lib.optionals (withWallet && !stdenv.isDarwin) [ db48 ]
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

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkFlags =
    [ "LC_ALL=en_US.UTF-8" ]
    # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
    # See also https://github.com/NixOS/nixpkgs/issues/24256
    ++ lib.optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Derivative of Bitcoin Core with a collection of improvements";
    homepage = "https://bitcoinknots.org/";
    maintainers = with maintainers; [ prusnak mmahut ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
