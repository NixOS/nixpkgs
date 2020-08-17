{ stdenv
, fetchurl
, pkgconfig
, autoreconfHook
, db48
, boost
, zeromq
, hexdump
, zlib
, miniupnpc
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
, utillinux
, python3
, qrencode
, libevent
, withGui
}:

with stdenv.lib;
let
  version = "0.20.1";
  majorMinorVersion = versions.majorMinor version;
  desktop = fetchurl {
    url = "https://raw.githubusercontent.com/bitcoin-core/packaging/${majorMinorVersion}/debian/bitcoin-qt.desktop";
    sha256 = "0cpna0nxcd1dw3nnzli36nf9zj28d2g9jf5y0zl9j18lvanvniha";
  };
in
stdenv.mkDerivation rec {
  pname = if withGui then "bitcoin" else "bitcoind";
  inherit version;

  src = fetchurl {
    urls = [
      "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
      "https://bitcoin.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
    ];
    sha256 = "4bbd62fd6acfa5e9864ebf37a24a04bc2dcfe3e3222f056056288d854c53b978";
  };

  nativeBuildInputs =
    [ pkgconfig autoreconfHook ]
    ++ optional stdenv.isDarwin hexdump
    ++ optional withGui wrapQtAppsHook;
  buildInputs = [ db48 boost zlib zeromq miniupnpc libevent ]
    ++ optionals stdenv.isLinux [ utillinux ]
    ++ optionals withGui [ qtbase qttools qrencode ];

  postInstall = optional withGui ''
    install -Dm644 ${desktop} $out/share/applications/bitcoin-qt.desktop
    install -Dm644 share/pixmaps/bitcoin128.png $out/share/pixmaps/bitcoin128.png
  '';

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-bench"
  ] ++ optionals (!doCheck) [
    "--disable-tests"
    "--disable-gui-tests"
  ]
  ++ optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  checkInputs = [ python3 ];

  doCheck = true;

  checkFlags =
    [ "LC_ALL=C.UTF-8" ]
    # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
    # See also https://github.com/NixOS/nixpkgs/issues/24256
    ++ optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription = ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "https://bitcoin.org/";
    downloadPage = "https://bitcoincore.org/bin/bitcoin-core-${version}/";
    changelog = "https://bitcoincore.org/en/releases/${version}/";
    maintainers = with maintainers; [ roconnor AndersonTorres ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
