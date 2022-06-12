{ lib
, stdenv
, fetchFromGitHub
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
, withGui
, withWallet ? true
}:

with lib;
stdenv.mkDerivation rec {
  pname = if withGui then "elements" else "elementsd";
  version = "0.21.0.2";

  src = fetchFromGitHub {
    owner = "ElementsProject";
    repo = "elements";
    rev = "elements-${version}";
    sha256 = "sha256-5b3wylp9Z2U0ueu2gI9jGeWiiJoddjcjQ/6zkFATyvA=";
  };

  nativeBuildInputs =
    [ autoreconfHook pkg-config ]
    ++ optionals stdenv.isLinux [ util-linux ]
    ++ optionals stdenv.isDarwin [ hexdump ]
    ++ optionals withGui [ wrapQtAppsHook ];

  buildInputs = [ boost libevent miniupnpc zeromq zlib ]
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
  };
}
