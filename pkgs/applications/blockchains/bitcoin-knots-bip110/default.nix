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
    "DAED928C727D3E613EC46635F5073C4F4882FFFC" # leo-haf.gpg
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "bitcoin-knots-bip110" else "bitcoind-knots-bip110";
  version = "29.2.knots20251110+bip110-v0.1rc1";

  src = fetchurl {
    url = "https://github.com/dathonohm/bitcoin/releases/download/v29.2.knots20251110%2Bbip110-v0.1rc1/bitcoin-${finalAttrs.version}.tar.gz";
    # hash retrieved from signed SHA256SUMS
    hash = "sha256-mOWUTsT65I4yGJogGieZbIxNSkSbCw+1x+LYGY1UJd8=";
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
        rev = "cc710f4715ff5ff74a9e89d8b6798884fe1e9d40";
        sha256 = "sha256-PVvsqY//75dv+VrtapCNroD1z1zUaA/UBGvfq3zNySo=";
      };

      checksums = fetchurl {
        url = "https://raw.githubusercontent.com/dathonohm/guix.sigs/refs/heads/bip110/29.2.knots20251110%2Bbip110-v0.1rc1/leo-haf/all.SHA256SUMS";
        hash = "sha256-1PXYBQuR8UI0ysLj9d/Vlvu/EQ/WoMne10cmjbYLJKM=";
      };

      signatures = fetchurl {
        url = "https://raw.githubusercontent.com/dathonohm/guix.sigs/refs/heads/bip110/29.2.knots20251110%2Bbip110-v0.1rc1/leo-haf/all.SHA256SUMS.asc";
        hash = "sha256-SMtyjDyYE65NR/bJh+0Lla+ItpXP8wqPQeGUN57LZHM=";
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
      ln -s ${checksums} ./all.SHA256SUMS
      ln -s ${signatures} ./all.SHA256SUMS.asc
      ln -s $src ./bitcoin-${finalAttrs.version}.tar.gz
      gpg --no-autostart --batch --verify --status-fd 1 all.SHA256SUMS.asc all.SHA256SUMS > verify.log
      ${verifyBuilderKeys}
      echo "Checking ${checksums} for bitcoin-${finalAttrs.version}.tar.gz..."
      grep bitcoin-${finalAttrs.version}.tar.gz all.SHA256SUMS > all.SHA256SUMS.filtered
      echo "Verifying the checksum of bitcoin-${finalAttrs.version}.tar.gz..."
      sha256sum -c all.SHA256SUMS.filtered
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

  NIX_LDFLAGS = lib.optionals (
    stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic
  ) "-levent_core";

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
  versionCheckProgramArg = "--version";
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
