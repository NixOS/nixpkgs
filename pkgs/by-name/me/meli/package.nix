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
  version = "0.8.10";

  src = fetchzip {
    urls = [
      "https://git.meli-email.org/meli/meli/archive/v${version}.tar.gz"
      "https://codeberg.org/meli/meli/archive/v${version}.tar.gz"
      "https://github.com/meli/meli/archive/refs/tags/v${version}.tar.gz"
    ];
    hash = "sha256-MGnCX/6pnKNxDEqCcVWTl/fteMypk+N2PrJYRMP0sL0=";
  };

  cargoHash = "sha256-w0fxh3c54Hcczc9NW8heewrRFx7UZnQqAHiQWZ43wKw=";

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
    "--skip=test_cli_subcommands" # panicking due to sandbox
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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
