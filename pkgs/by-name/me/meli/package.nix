{
  stdenv,
  lib,
  fetchzip,
  fetchpatch,
  rustPlatform,

  # native build inputs
  pkg-config,
  installShellFiles,
  makeWrapper,
  mandoc,
  rustfmt,
  file,

  # build inputs
  openssl,
  dbus,
  sqlite,

  # runtime deps
  gpgme,
  gnum4,
}:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "0.8.7";

  src = fetchzip {
    urls = [
      "https://git.meli-email.org/meli/meli/archive/v${version}.tar.gz"
      "https://codeberg.org/meli/meli/archive/v${version}.tar.gz"
      "https://github.com/meli/meli/archive/refs/tags/v${version}.tar.gz"
    ];
    hash = "sha256-2+JIehi2wuWdARbhFPvNPIJ9ucZKWjNSORszEG9lyjw=";
  };

  cargoHash = "sha256-ZVhUkpiiPKbWcf56cXFgn3Nyr63STHLlD7mpYEetNIY=";

  cargoPatches = [
    (fetchpatch {
      # https://github.com/NixOS/nixpkgs/issues/332957#issuecomment-2278578811
      name = "fix-rust-1.80-compat.patch";
      url = "https://git.meli-email.org/meli/meli/commit/6b05279a0987315c401516cac8ff0b016a8e02a8.patch";
      hash = "sha256-mh8H7wmHMXAe01UTvdY8vJeeLyH6ZFwylNLFFL+4LO0=";
    })
  ];

  # Needed to get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
    mandoc
    (rustfmt.override { asNightly = true; })
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ];

  nativeCheckInputs = [
    file
    gnum4
  ];

  postInstall = ''
    installManPage meli/docs/*.{1,5,7}

    wrapProgram $out/bin/meli \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gpgme ]} \
      --prefix PATH : ${lib.makeBinPath [ gnum4 ]}
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    "--skip=conf::tests::test_config_parse" # panicking due to sandbox
    "--skip=utils::tests::test_shellexpandtrait_impls" # panicking due to sandbox
    "--skip=utils::tests::test_shellexpandtrait" # panicking due to sandbox
  ];

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Terminal e-mail client and e-mail client library";
    mainProgram = "meli";
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      _0x4A6F
      matthiasbeyer
    ];
    platforms = platforms.linux;
  };
}
