{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, util-linux
, hexdump
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
, openssl
, withGui
, withWallet ? true
}:

with lib;
stdenv.mkDerivation rec {
  pname = if withGui then "elements" else "elementsd";
  version = "0.18.1.12";

  src = fetchurl {
    url = "https://github.com/ElementsProject/elements/archive/elements-${version}.tar.gz";
    sha256 = "84a51013596b09c62913649ac90373622185f779446ee7e65b4b258a2876609f";
  };

  nativeBuildInputs =
    [ autoreconfHook pkg-config ]
    ++ optionals stdenv.isLinux [ util-linux ]
    ++ optionals stdenv.isDarwin [ hexdump ]
    ++ optionals withGui [ wrapQtAppsHook ];

  buildInputs = [ boost libevent miniupnpc zeromq zlib openssl ]
    ++ optionals withWallet [ db48 sqlite ]
    ++ optionals withGui [ qrencode qtbase qttools ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-bench"
  ] ++ optionals (!doCheck) [
    "--disable-tests"
    "--disable-gui-tests"
  ] ++ optionals (!withWallet) [
    "--disable-wallet"
  ] ++ optionals withGui [
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
    description = "Open Source implementation of advanced blockchain features extending the Bitcoin protocol";
    longDescription= ''
      The Elements blockchain platform is a collection of feature experiments and extensions to the
      Bitcoin protocol. This platform enables anyone to build their own businesses or networks
      pegged to Bitcoin as a sidechain or run as a standalone blockchain with arbitrary asset
      tokens.
    '';
    homepage = "https://www.github.com/ElementsProject/elements";
    maintainers = with maintainers; [ prusnak ];
    license = licenses.mit;
    platforms = platforms.unix;
    # Qt GUI is currently broken in upstream
    # No rule to make target 'qt/res/rendered_icons/about.png', needed by 'qt/qrc_bitcoin.cpp'.
    broken = withGui;
  };
}
