{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  util-linux,
  hexdump,
  autoSignDarwinBinariesHook,
  wrapQtAppsHook ? null,
  boost,
  libevent,
  miniupnpc,
  zeromq,
  zlib,
  db48,
  sqlite,
  qrencode,
  qtbase ? null,
  qttools ? null,
  python3,
  withGui,
  withWallet ? true,
}:

stdenv.mkDerivation rec {
  pname = if withGui then "bitcoin-knots" else "bitcoind-knots";
  version = "28.1.knots20250305";

  src = fetchurl {
    url = "https://bitcoinknots.org/files/28.x/${version}/bitcoin-${version}.tar.gz";
    hash = "sha256-DKO3+43Tn/BTKQVrLrCkeMtzm8SfbaJD8rPlb6lDA8A=";
  };

  nativeBuildInputs =
    [
      autoreconfHook
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ util-linux ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ hexdump ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      autoSignDarwinBinariesHook
    ]
    ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs =
    [
      boost
      libevent
      miniupnpc
      zeromq
      zlib
    ]
    ++ lib.optionals withWallet [ sqlite ]
    ++ lib.optionals (withWallet && !stdenv.hostPlatform.isDarwin) [ db48 ]
    ++ lib.optionals withGui [
      qrencode
      qtbase
      qttools
    ];

  configureFlags =
    [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-bench"
    ]
    ++ lib.optionals (!doCheck) [
      "--disable-tests"
      "--disable-gui-tests"
    ]
    ++ lib.optionals (!withWallet) [
      "--disable-wallet"
    ]
    ++ lib.optionals withGui [
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

  meta = {
    description = "Derivative of Bitcoin Core with a collection of improvements";
    homepage = "https://bitcoinknots.org/";
    changelog = "https://github.com/bitcoinknots/bitcoin/blob/v${version}/doc/release-notes.md";
    maintainers = with lib.maintainers; [
      prusnak
      mmahut
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
