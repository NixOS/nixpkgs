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
, gmp
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

with lib;
let
  version = "0.18.0";
  desktop = fetchurl {
    url = "https://raw.githubusercontent.com/vertcoin-project/packaging/${version}/debian/vertcoin-qt.desktop";
    sha256 = "b0ee78ca7fd3938fca831f57a677eb8795a4fb7e28d250fbb6a572175c5e69d5";
  };
in
stdenv.mkDerivation rec {
  pname = if withGui then "vertcoin" else "vertcoind";
  inherit version;

  src = fetchurl {
    urls = [
      "https://github.com/vertcoin-project/vertcoin-core/releases/download/${version}/vertcoin-${version}.tar.gz"
    ];
    sha256 = "32a3ab16c6680f43962ce4f62f8397f4d6111d4e589ae70d298b29526a62afc5";
  };

  nativeBuildInputs =
    [ autoreconfHook pkg-config ]
    ++ optionals stdenv.isLinux [ util-linux ]
    ++ optionals stdenv.isDarwin [ hexdump ]
    ++ optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ]
    ++ optionals withGui [ wrapQtAppsHook ];

  buildInputs = [ boost libevent gmp miniupnpc zeromq zlib ]
    ++ optionals withWallet [ db48 sqlite ]
    ++ optionals withGui [ qrencode qtbase qttools ];

  postInstall = optionalString withGui ''
    install -Dm644 ${desktop} $out/share/applications/vertcoin-qt.desktop
    substituteInPlace $out/share/applications/vertcoin-qt.desktop --replace "Icon=vertcoin128" "Icon=vertcoin"
    install -Dm644 share/pixmaps/vertcoin256.png $out/share/pixmaps/vertcoin.png
  '';

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-bench"
    "--disable-tests"
  ] ++ optionals (!withWallet) [
    "--disable-wallet"
  ] ++ optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  checkInputs = [ python3 ];

  doCheck = true;

  checkFlags =
    [ "LC_ALL=en_US.UTF-8" ]
    # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
    # See also https://github.com/NixOS/nixpkgs/issues/24256
    ++ optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription = ''
      Vertcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "https://vertcoin.org/en/";
    downloadPage = "https://github.com/vertcoin-project/vertcoin-core/releases/tag/${version}/";
    changelog = "https://github.com/vertcoin-project/vertcoin-core/releases/tag/${version}/";
    maintainers = with maintainers; [ vertion ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
