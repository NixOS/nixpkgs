{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
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
  gnupg,
  # Signatures from the following GPG public keys checked during verification of the source code.
  # The list can be found at https://github.com/bitcoinknots/guix.sigs/tree/knots/builder-keys
  builderKeys ? [
    "1A3E761F19D2CC7785C5502EA291A2C45D0C504A" # luke-jr.gpg
    "32FE1E61B1C711186CA378DEFD8981F1BC41ABB9" # oomahq.gpg
    "CACC7CBB26B3D2EE8FC2F2BC0E37EBAB8574F005" # leo-haf.gpg
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "bitcoin-knots" else "bitcoind-knots";
  version = "28.1.knots20250305";

  src = fetchurl {
    url = "https://bitcoinknots.org/files/28.x/${finalAttrs.version}/bitcoin-${finalAttrs.version}.tar.gz";
    # hash retrieved from signed SHA256SUMS
    hash = "sha256-DKO3+43Tn/BTKQVrLrCkeMtzm8SfbaJD8rPlb6lDA8A=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gnupg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ util-linux ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ hexdump ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    autoSignDarwinBinariesHook
  ]
  ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs = [
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

  preUnpack =
    let
      majorVersion = lib.versions.major finalAttrs.version;

      publicKeys = fetchFromGitHub {
        owner = "bitcoinknots";
        repo = "guix.sigs";
        rev = "b998306d462f39b6077518521700d7156fec76b8";
        sha256 = "sha256-q4tumAfTr828AZNOa9ia7Y0PYoe6W47V/7SEApTzl3w=";
      };

      checksums = fetchurl {
        url = "https://bitcoinknots.org/files/${majorVersion}.x/${finalAttrs.version}/SHA256SUMS";
        hash = "sha256-xWJKaZBLm9H6AuMBSC21FLy/5TRUI0AQVIUF/2PvDhs=";
      };

      signatures = fetchurl {
        url = "https://bitcoinknots.org/files/${majorVersion}.x/${finalAttrs.version}/SHA256SUMS.asc";
        hash = "sha256-SywdBEzZqsf2aDeOs7J9n513RTCm+TJA/QYP5+h7Ifo=";
      };

      verifyBuilderKeys =
        let
          script = publicKey: ''
            echo "Checking if public key ${publicKey} signed the checksum file..."
            grep "^\[GNUPG:\] VALIDSIG .* ${publicKey}$" verify.log > /dev/null
            echo "OK"
          '';
        in
        builtins.concatStringsSep "\n" (builtins.map script builderKeys);
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
      grep bitcoin-${finalAttrs.version}.tar.gz SHA256SUMS > SHA256SUMS.filtered
      echo "Verifying the checksum of bitcoin-${finalAttrs.version}.tar.gz..."
      sha256sum -c SHA256SUMS.filtered
      popd
    '';

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
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkFlags = [
    "LC_ALL=en_US.UTF-8"
  ]
  # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
  # See also https://github.com/NixOS/nixpkgs/issues/24256
  ++ lib.optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = {
    description = "Derivative of Bitcoin Core with a collection of improvements";
    homepage = "https://bitcoinknots.org/";
    changelog = "https://github.com/bitcoinknots/bitcoin/blob/v${finalAttrs.version}/doc/release-notes.md";
    maintainers = with lib.maintainers; [
      prusnak
      mmahut
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
