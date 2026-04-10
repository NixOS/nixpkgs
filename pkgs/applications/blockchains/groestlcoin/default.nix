{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  pkg-config,
  installShellFiles,
  autoSignDarwinBinariesHook,
  wrapQtAppsHook ? null,
  boost,
  libevent,
  zeromq,
  zlib,
  db53,
  sqlite,
  qrencode,
  libsystemtap,
  qtbase ? null,
  qttools ? null,
  python3,
  versionCheckHook,
  withGui ? false,
  withWallet ? true,
}:

let
  desktop = fetchurl {
    # de45048 is the last commit when the debian/groestlcoin-qt.desktop file was changed
    url = "https://raw.githubusercontent.com/Groestlcoin/packaging/de4504844e47cf2c7604789650a5db4f3f7a48aa/debian/groestlcoin-qt.desktop";
    sha256 = "0mxwq4jvcip44a796iwz7n1ljkhl3a4p47z7qlsxcfxw3zmm0k0k";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "groestlcoin" else "groestlcoind";
  version = "29.0";

  src = fetchFromGitHub {
    owner = "Groestlcoin";
    repo = "groestlcoin";
    rev = "v${finalAttrs.version}";
    sha256 = "17b83jch717d91srw1yc93p8ndl894ld9gx916wyy6jis07px6xh";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    autoSignDarwinBinariesHook
  ]
  ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs = [
    boost
    libevent
    zeromq
    zlib
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ libsystemtap ]
  ++ lib.optionals withWallet [
    db53
    sqlite
  ]
  ++ lib.optionals withGui [
    qrencode
    qtbase
    qttools
  ];

  postInstall = ''
      cd ..
      installShellCompletion --bash contrib/completions/bash/groestlcoin-cli.bash
      installShellCompletion --bash contrib/completions/bash/groestlcoind.bash
      installShellCompletion --bash contrib/completions/bash/groestlcoin-tx.bash

    for file in contrib/completions/fish/groestlcoin-*.fish; do
      installShellCompletion --fish $file
    done
  ''
  + lib.optionalString withGui ''
    installShellCompletion --fish contrib/completions/fish/groestlcoin-qt.fish

    install -Dm644 ${desktop} $out/share/applications/groestlcoin-qt.desktop
    substituteInPlace $out/share/applications/groestlcoin-qt.desktop --replace "Icon=groestlcoin128" "Icon=groestlcoin"
    install -Dm644 share/pixmaps/groestlcoin256.png $out/share/icons/hicolor/256x256/apps/groestlcoin.png
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_BENCH" false)
    (lib.cmakeBool "WITH_ZMQ" true)
    (lib.cmakeBool "WITH_USDT" (stdenv.hostPlatform.isLinux))
    (lib.cmakeBool "ENABLE_WALLET" (!withWallet))
    (lib.cmakeBool "BUILD_GUI" (!withGui))
    (lib.cmakeBool "ENABLE_WALLET" false)
  ]
  ++ lib.optionals withGui [
    (lib.cmakeBool "BUILD_GUI" true)
  ];

  nativeCheckInputs = [ python3 ];

  checkFlags = [
    "LC_ALL=en_US.UTF-8"
  ]
  # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Groestlcoin's GUI.
  # See also https://github.com/NixOS/nixpkgs/issues/24256
  ++ lib.optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/groestlcoin-cli";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription = ''
      Groestlcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "https://groestlcoin.org/";
    downloadPage = "https://github.com/Groestlcoin/groestlcoin/releases/tag/v${finalAttrs.version}/";
    changelog = "https://github.com/Groestlcoin/groestlcoin/blob/${finalAttrs.version}.0/doc/release-notes/release-notes-${finalAttrs.version}.0.md";
    maintainers = with lib.maintainers; [ gruve-p ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
