{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost, zeromq, rapidcheck
, zlib, miniupnpc, qtbase ? null, qttools ? null, wrapQtAppsHook ? null, utillinux, protobuf, python3, qrencode, libevent
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{
  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.18.1";

  src = fetchurl {
    urls = [ "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
             "https://bitcoin.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
           ];
    sha256 = "5c7d93f15579e37aa2d1dc79e8f5ac675f59045fceddf604ae0f1550eb03bf96";
  };

  nativeBuildInputs =
    [ pkgconfig autoreconfHook ]
    ++ optional withGui wrapQtAppsHook;
  buildInputs = [ openssl db48 boost zlib zeromq
                  miniupnpc protobuf libevent]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

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
    # bitcoin needs hexdump to build, which doesn't seem to build on darwin at the moment.
    platforms = platforms.linux;
  };
}
