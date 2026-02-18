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
  libsodium,
  zeromq,
  zlib,
  db48,
  sqlite,
  qrencode,
  libsystemtap,
  qtbase ? null,
  qttools ? null,
  python3,
  versionCheckHook,
  withGui,
  withWallet ? true,
  enableTracing ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isStatic,
  gnupg,
  imagemagick,
  librsvg,
  libicns,
  # Signatures from the following GPG public keys checked during verification of the source code.
  # The list can be found at https://github.com/bitcoinknots/guix.sigs/tree/knots/builder-keys
  builderKeys ? [
    "1A3E761F19D2CC7785C5502EA291A2C45D0C504A" # luke-jr.gpg
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "bitcoin-knots-bip110" else "bitcoind-knots-bip110";
  version = "29.3.knots20260210+bip110-v0.3";

  src = fetchurl {
    url = "https://github.com/dathonohm/bitcoin/releases/download/v29.3.knots20260210%2Bbip110-v0.3/bitcoin-${finalAttrs.version}.tar.gz";
    # hash retrieved from signed SHA256SUMS
    hash = "sha256-Wu+owbzUxhKG5ma1PQihsngVLgqWTv8VdSGG/qzn3Xs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
    gnupg
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    autoSignDarwinBinariesHook
  ]
  ++ lib.optionals withGui [
    imagemagick # for convert
    librsvg # for rsvg-convert
    wrapQtAppsHook
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && withGui) [
    libicns # for png2icns
  ];

  buildInputs = [
    boost
    libevent
    libsodium
    zeromq
    zlib
  ]
  ++ lib.optionals enableTracing [ libsystemtap ]
  ++ lib.optionals withWallet [ sqlite ]
  # building with db48 (for legacy descriptor wallet support) is broken on Darwin
  ++ lib.optionals (withWallet && !stdenv.hostPlatform.isDarwin) [ db48 ]
  ++ lib.optionals withGui [
    qrencode
    qtbase
    qttools
  ];

  preUnpack =
    let
      majorVersion = lib.versions.major finalAttrs.version;

      publicKeys = fetchFromGitHub {
        owner = "bitcoinknots";
        repo = "guix.sigs";
        rev = "e34c3262de92940f4dc35e67abed84499c670af2";
        sha256 = "sha256-Zrhe7xK/7YnIfyXlMd/jpO6Ab1dNVK0S1vwdhhH3Xuc=";
      };

      checksums = fetchurl {
        url = "https://raw.githubusercontent.com/dathonohm/guix.sigs/refs/heads/bip110/29.3.knots20260210%2Bbip110-v0.3/luke-jr/all.SHA256SUMS";
        hash = "sha256-6gd/dmVTjhAyuryCtf3t2jxTZRLuukHnt4TAQM8dQ/E=";
      };

      signatures = fetchurl {
        url = "https://raw.githubusercontent.com/dathonohm/guix.sigs/refs/heads/bip110/29.3.knots20260210%2Bbip110-v0.3/luke-jr/all.SHA256SUMS.asc";
        hash = "sha256-C4uQZamdVA0WAgi3Q+6oXybNIbNteWBcDS5TCtkGLh0=";
      };

      verifyBuilderKeys =
        let
          script = publicKey: ''
            echo "Checking if public key ${publicKey} signed the checksum file..."
            grep "^\[GNUPG:\] VALIDSIG .* ${publicKey}$" verify.log > /dev/null
            echo "OK"
          '';
        in
        builtins.concatStringsSep "\n" (map script builderKeys);
    in
    ''
      pushd $(mktemp -d)
      export GNUPGHOME=$PWD/gnupg
      mkdir -m 700 -p $GNUPGHOME
      gpg --no-autostart --batch --import ${publicKeys}/builder-keys/*
      ln -s ${checksums} ./SHA256SUMS
      ln -s ${signatures} ./SHA256SUMS.asc
      ln -s $src ./bitcoin-${finalAttrs.version}.tar.gz
      gpg --no-autostart --batch --verify --status-fd 1 SHA256SUMS.asc SHA256SUMS > verify.log
      ${verifyBuilderKeys}
      echo "Checking ${checksums} for bitcoin-${finalAttrs.version}.tar.gz..."
      grep bitcoin-${finalAttrs.version}.tar.gz SHA256SUMS > SHA256SUMS.filtered
      echo "Verifying the checksum of bitcoin-${finalAttrs.version}.tar.gz..."
      sha256sum -c SHA256SUMS.filtered
      popd
    '';

  postInstall = ''
    cd ..
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
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_BENCH" false)
    (lib.cmakeBool "WITH_ZMQ" true)
    # building with db48 (for legacy wallet support) is broken on Darwin
    (lib.cmakeBool "WITH_BDB" (withWallet && !stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "WITH_USDT" enableTracing)
  ]
  ++ lib.optionals (!finalAttrs.doCheck) [
    (lib.cmakeBool "BUILD_TESTS" false)
    (lib.cmakeBool "BUILD_FUZZ_BINARY" false)
    (lib.cmakeBool "BUILD_GUI_TESTS" false)
  ]
  ++ lib.optionals (!withWallet) [
    (lib.cmakeBool "ENABLE_WALLET" false)
  ]
  ++ lib.optionals withGui [
    (lib.cmakeBool "BUILD_GUI" true)
  ];

  env = lib.optionalAttrs (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic) {
    NIX_LDFLAGS = "-levent_core";
  };

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkFlags = [
    "LC_ALL=en_US.UTF-8"
  ]
  # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
  # See also https://github.com/NixOS/nixpkgs/issues/24256
  ++ lib.optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bitcoin-cli";
  doInstallCheck = true;

  meta = {
    description = "Derivative of Bitcoin Knots with BIP 110";
    homepage = "https://github.com/dathonohm/bips/blob/ff8f8d6415dd24daacc73294d4f933b6ce1ef199/bip-0110.mediawiki";
    maintainers = with lib.maintainers; [
      prusnak
      mmahut
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
