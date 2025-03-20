{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  installShellFiles,
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
  versionCheckHook,
  nixosTests,
  withGui,
  withWallet ? true,
}:

let
  desktop = fetchurl {
    # c2e5f3e is the last commit when the debian/bitcoin-qt.desktop file was changed
    url = "https://raw.githubusercontent.com/bitcoin-core/packaging/c2e5f3e20a8093ea02b73cbaf113bc0947b4140e/debian/bitcoin-qt.desktop";
    sha256 = "0cpna0nxcd1dw3nnzli36nf9zj28d2g9jf5y0zl9j18lvanvniha";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "bitcoin" else "bitcoind";
  version = "28.1";

  src = fetchurl {
    urls = [
      "https://bitcoincore.org/bin/bitcoin-core-${finalAttrs.version}/bitcoin-${finalAttrs.version}.tar.gz"
    ];
    # hash retrieved from signed SHA256SUMS
    sha256 = "c5ae2dd041c7f9d9b7c722490ba5a9d624f7e9a089c67090615e1ba4ad0883ba";
  };

  nativeBuildInputs =
    [
      autoreconfHook
      pkg-config
      installShellFiles
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
    # building with db48 (for legacy descriptor wallet support) is broken on Darwin
    ++ lib.optionals (withWallet && !stdenv.hostPlatform.isDarwin) [ db48 ]
    ++ lib.optionals withGui [
      qrencode
      qtbase
      qttools
    ];

  postInstall =
    ''
      installShellCompletion --bash contrib/completions/bash/bitcoin-cli.bash
      installShellCompletion --bash contrib/completions/bash/bitcoind.bash
      installShellCompletion --bash contrib/completions/bash/bitcoin-tx.bash

      installShellCompletion --fish contrib/completions/fish/bitcoin-cli.fish
      installShellCompletion --fish contrib/completions/fish/bitcoind.fish
      installShellCompletion --fish contrib/completions/fish/bitcoin-tx.fish
      installShellCompletion --fish contrib/completions/fish/bitcoin-util.fish
      installShellCompletion --fish contrib/completions/fish/bitcoin-wallet.fish
    ''
    + lib.optionalString withGui ''
      installShellCompletion --fish contrib/completions/fish/bitcoin-qt.fish

      install -Dm644 ${desktop} $out/share/applications/bitcoin-qt.desktop
      substituteInPlace $out/share/applications/bitcoin-qt.desktop --replace "Icon=bitcoin128" "Icon=bitcoin"
      install -Dm644 share/pixmaps/bitcoin256.png $out/share/pixmaps/bitcoin.png
    '';

  configureFlags =
    [
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

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bitcoin-cli";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.tests = {
    smoke-test = nixosTests.bitcoind;
  };

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription = ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "https://bitcoin.org/en/";
    downloadPage = "https://bitcoincore.org/bin/bitcoin-core-${finalAttrs.version}/";
    changelog = "https://bitcoincore.org/en/releases/${finalAttrs.version}/";
    maintainers = with lib.maintainers; [
      prusnak
      roconnor
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
