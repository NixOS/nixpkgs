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
  sqlite,
  qrencode,
  libsystemtap,
  capnproto,
  qtbase ? null,
  qttools ? null,
  python3,
  versionCheckHook,
  nixosTests,
  withGui,
  withWallet ? true,
  enableTracing ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isStatic,
  gnupg,
  # Signatures from the following GPG public keys checked during verification of the source code.
  # The list can be found at https://github.com/bitcoin-core/guix.sigs/tree/main/builder-keys
  builderKeys ? [
    "152812300785C96444D3334D17565732E08E5E41" # achow101.gpg
    "9EDAFF80E080659604F4A76B2EBB056FD847F8A7" # Emzy.gpg
    # "6B002C6EA3F91B1B0DF0C9BC8F617F1200A6D25C" # glozow.gpg (not signed 30.2)
    "D1DBF2C4B96F2DEBF4C16654410108112E7EA81F" # hebasto.gpg
    # "71A3B16735405025D447E8F274810B012346C9A6" # laanwj.gpg (not signed 30.2)
    # "67AA5B46E7AF78053167FE343B8F814A784218F8" # willcl-ark.gpg (not signed 30.2)
  ],
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
  version = "30.2";

  src = fetchurl {
    urls = [
      "https://bitcoincore.org/bin/bitcoin-core-${finalAttrs.version}/bitcoin-${finalAttrs.version}.tar.gz"
    ];
    # hash retrieved from signed SHA256SUMS
    sha256 = "6fd00b8c42883d5c963901ad4109a35be1e5ec5c2dc763018c166c21a06c84cb";
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
  ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs = [
    boost
    libevent
    zeromq
    zlib
    capnproto
  ]
  ++ lib.optionals enableTracing [ libsystemtap ]
  ++ lib.optionals withWallet [ sqlite ]
  ++ lib.optionals withGui [
    qrencode
    qtbase
    qttools
  ];

  preUnpack =
    let
      publicKeys = fetchFromGitHub {
        owner = "bitcoin-core";
        repo = "guix.sigs";
        rev = "8427342623f66a98e4b2503e5e15eb41485200d2";
        sha256 = "sha256-X1mA1iPAb0OE9RNP9O5rFe9rzsui+BWQ2zMcV7SghXE=";
      };

      checksums = fetchurl {
        url = "https://bitcoincore.org/bin/bitcoin-core-${finalAttrs.version}/SHA256SUMS";
        hash = "sha256-ERE/QO2elj++mON3UYGJKaLdU86gWIRS/AufuyS/JAU=";
      };

      signatures = fetchurl {
        url = "https://bitcoincore.org/bin/bitcoin-core-${finalAttrs.version}/SHA256SUMS.asc";
        hash = "sha256-69TMNzKJQRDC+2YU6bKI23c8Jx44m5B1zz823SQtiyg=";
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

    install -Dm644 ${desktop} $out/share/applications/bitcoin-qt.desktop
    substituteInPlace $out/share/applications/bitcoin-qt.desktop --replace "Icon=bitcoin128" "Icon=bitcoin"
    install -Dm644 share/pixmaps/bitcoin256.png $out/share/icons/hicolor/256x256/apps/bitcoin.png
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_BENCH" false)
    (lib.cmakeBool "WITH_ZMQ" true)
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
