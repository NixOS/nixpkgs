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

let
  desktop = fetchurl {
    # c2e5f3e is the last commit when the debian/bitcoin-qt.desktop file was changed
    url = "https://raw.githubusercontent.com/bitcoin-core/packaging/c2e5f3e20a8093ea02b73cbaf113bc0947b4140e/debian/bitcoin-qt.desktop";
    sha256 = "0cpna0nxcd1dw3nnzli36nf9zj28d2g9jf5y0zl9j18lvanvniha";
  };
in
stdenv.mkDerivation rec {
  pname = if withGui then "bitcoin" else "bitcoind";
  version = "24.0.1";

  src = fetchurl {
    urls = [
      "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
    ];
    # hash retrieved from signed SHA256SUMS
    sha256 = "12d4ad6dfab4767d460d73307e56d13c72997e114fad4f274650f95560f5f2ff";
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

  postInstall = lib.optionalString withGui ''
    install -Dm644 ${desktop} $out/share/applications/bitcoin-qt.desktop
    substituteInPlace $out/share/applications/bitcoin-qt.desktop --replace "Icon=bitcoin128" "Icon=bitcoin"
    install -Dm644 share/pixmaps/bitcoin256.png $out/share/pixmaps/bitcoin.png
  '';

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

  passthru.tests = {
    smoke-test = nixosTests.bitcoind;
  };

  meta = with lib; {
    description = "Peer-to-peer electronic cash system";
    longDescription = ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "https://bitcoin.org/en/";
    downloadPage = "https://bitcoincore.org/bin/bitcoin-core-${version}/";
    changelog = "https://bitcoincore.org/en/releases/${version}/";
    maintainers = with maintainers; [ prusnak roconnor ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
