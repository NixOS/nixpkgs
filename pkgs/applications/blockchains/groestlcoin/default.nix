{ lib
, stdenv
, fetchurl
, fetchFromGitHub
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
, db53
, sqlite
, qrencode
, qtbase ? null
, qttools ? null
, python3
, withGui ? false
, withWallet ? true
}:

let
  desktop = fetchurl {
    # de45048 is the last commit when the debian/groestlcoin-qt.desktop file was changed
    url = "https://raw.githubusercontent.com/Groestlcoin/packaging/de4504844e47cf2c7604789650a5db4f3f7a48aa/debian/groestlcoin-qt.desktop";
    sha256 = "0mxwq4jvcip44a796iwz7n1ljkhl3a4p47z7qlsxcfxw3zmm0k0k";
  };
in
stdenv.mkDerivation rec {
  pname = if withGui then "groestlcoin" else "groestlcoind";
  version = "25.0";

  src = fetchFromGitHub {
    owner = "Groestlcoin";
    repo = "groestlcoin";
    rev = "v${version}";
    sha256 = "03w5n3qjha63mgj7zk8q17x5j63la3i4li7bf5i1yw59ijqpmnqg";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ]
    ++ lib.optionals stdenv.isLinux [ util-linux ]
    ++ lib.optionals stdenv.isDarwin [ hexdump ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ]
    ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs = [ boost libevent miniupnpc zeromq zlib ]
    ++ lib.optionals withWallet [ db53 sqlite ]
    ++ lib.optionals withGui [ qrencode qtbase qttools ];

  postInstall = lib.optionalString withGui ''
    install -Dm644 ${desktop} $out/share/applications/groestlcoin-qt.desktop
    substituteInPlace $out/share/applications/groestlcoin-qt.desktop --replace "Icon=groestlcoin128" "Icon=groestlcoin"
    install -Dm644 share/pixmaps/groestlcoin256.png $out/share/pixmaps/groestlcoin.png
  '';

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-bench"
  ] ++ lib.optionals (!withWallet) [
    "--disable-wallet"
  ] ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  nativeCheckInputs = [ python3 ];

  checkFlags = [ "LC_ALL=en_US.UTF-8" ]
    # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Groestlcoin's GUI.
    # See also https://github.com/NixOS/nixpkgs/issues/24256
    ++ lib.optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Peer-to-peer electronic cash system";
    longDescription = ''
      Groestlcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "https://groestlcoin.org/";
    downloadPage = "https://github.com/Groestlcoin/groestlcoin/releases/tag/v{version}/";
    maintainers = with maintainers; [ gruve-p ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
