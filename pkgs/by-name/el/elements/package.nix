{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  util-linux,
  hexdump,
  darwin,
  boost,
  libevent,
  miniupnpc,
  zeromq,
  zlib,
  db48,
  sqlite,
  qrencode,
  libsForQt5,
  python3,
  withGui ? true,
  withWallet ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "elements" else "elementsd";
  version = "23.3.2";

  src = fetchFromGitHub {
    owner = "ElementsProject";
    repo = "elements";
    rev = "elements-${finalAttrs.version}";
    sha256 = "sha256-NLLM+stYOXcnAjEfXRerjvgMXM8jFSOyZhu/A0ZTnRw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ util-linux ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ hexdump ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ]
  ++ lib.optionals withGui [ libsForQt5.wrapQtAppsHook ];

  buildInputs = [
    boost
    libevent
    miniupnpc
    zeromq
    zlib
  ]
  ++ lib.optionals withWallet [
    db48
    sqlite
  ]
  ++ lib.optionals withGui [
    qrencode
    libsForQt5.qtbase
    libsForQt5.qttools
  ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-bench"
  ]
  ++ lib.optionals (!finalAttrs.doCheck) [
    "--disable-tests"
    "--disable-gui-tests"
  ]
  ++ lib.optionals (!withWallet) [
    "--disable-wallet"
  ]
  ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${libsForQt5.qtbase.dev}/bin:${libsForQt5.qttools.dev}/bin"
  ];

  # fix "Killed: 9  test/test_bitcoin"
  # https://github.com/NixOS/nixpkgs/issues/179474
  hardeningDisable = lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin) [
    "fortify"
    "stackprotector"
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkFlags = [
    "LC_ALL=en_US.UTF-8"
  ]
  # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
  # See also https://github.com/NixOS/nixpkgs/issues/24256
  ++ lib.optional withGui "QT_PLUGIN_PATH=${libsForQt5.qtbase}/${libsForQt5.qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = {
    description = "Open Source implementation of advanced blockchain features extending the Bitcoin protocol";
    longDescription = ''
      The Elements blockchain platform is a collection of feature experiments and extensions to the
      Bitcoin protocol. This platform enables anyone to build their own businesses or networks
      pegged to Bitcoin as a sidechain or run as a standalone blockchain with arbitrary asset
      tokens.
    '';
    homepage = "https://www.github.com/ElementsProject/elements";
    maintainers = with lib.maintainers; [ prusnak ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
