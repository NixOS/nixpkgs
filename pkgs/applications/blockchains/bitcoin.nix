{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost, zeromq, rapidcheck, hexdump
, zlib, miniupnpc, qtbase ? null, qttools ? null, wrapQtAppsHook ? null, utillinux, python3, qrencode, libevent
, withGui }:

with stdenv.lib;

let
  version = "0.19.0.1";
  majorMinorVersion = versions.majorMinor version;

  desktop = fetchurl {
    url = "https://raw.githubusercontent.com/bitcoin-core/packaging/${majorMinorVersion}/debian/bitcoin-qt.desktop";
    sha256 = "0cpna0nxcd1dw3nnzli36nf9zj28d2g9jf5y0zl9j18lvanvniha";
  };

  pixmap = fetchurl {
    url = "https://raw.githubusercontent.com/bitcoin/bitcoin/v${version}/share/pixmaps/bitcoin128.png";
    sha256 = "08p7j7dg50jlj783kkgdw037klmx0spqjikaprmbkzgcb620r25d";
  };

in stdenv.mkDerivation rec {
  pname = if withGui then "bitcoin" else "bitcoind";
  inherit version;

  src = fetchurl {
    urls = [ "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
             "https://bitcoin.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
           ];
    sha256 = "7ac9f972249a0a16ed01352ca2a199a5448fe87a4ea74923404a40b4086de284";
  };

  nativeBuildInputs =
    [ pkgconfig autoreconfHook ]
    ++ optional stdenv.isDarwin hexdump
    ++ optional withGui wrapQtAppsHook;
  buildInputs = [ openssl db48 boost zlib zeromq
                  miniupnpc libevent]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

  postInstall = optional withGui ''
    install -Dm644 ${desktop} $out/share/applications/bitcoin-qt.desktop
    install -Dm644 ${pixmap} $out/share/pixmaps/bitcoin128.png
  '';

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib"
                     "--disable-bench"
                   ] ++ optionals (!doCheck) [
                     "--disable-tests"
                     "--disable-gui-tests"
                   ]
                     ++ optionals withGui [ "--with-gui=qt5"
                                            "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
                                          ];

  checkInputs = [ rapidcheck python3 ];

  doCheck = true;

  checkFlags =
    [ "LC_ALL=C.UTF-8" ]
    # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
    # See also https://github.com/NixOS/nixpkgs/issues/24256
    ++ optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = http://www.bitcoin.org/;
    maintainers = with maintainers; [ roconnor AndersonTorres ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
