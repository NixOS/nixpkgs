{
  stdenv,
  lib,
  fetchzip,
  rustPlatform,

  # native build inputs
  pkg-config,
  installShellFiles,
  makeWrapper,
  mandoc,
  rustfmt,
  file,
  writableTmpDirAsHomeHook,

  # build inputs
  openssl,
  dbus,
  sqlite,

  # runtime deps
  gpgme,
  gnum4,

  withNotmuch ? true,
  notmuch,
}:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "0.8.13";

  src = fetchzip {
    urls = [
      "https://git.meli-email.org/meli/meli/archive/v${version}.tar.gz"
      "https://codeberg.org/meli/meli/archive/v${version}.tar.gz"
      "https://github.com/meli/meli/archive/refs/tags/v${version}.tar.gz"
    ];
    hash = "sha256-uyhxNEKoRKrqvU76SuTKl1wlwOdHIxMFLXB5LwsdvQE=";
  };

  cargoHash = "sha256-wDj4g5Cjm6zedjCmpc/A40peHO951lLuEQGsn+i3eT0=";

  # Needed to get openssl-sys to use pkg-config
  env.OPENSSL_NO_VENDOR = 1;

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
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    installManPage meli/docs/*.{1,5,7}

    wrapProgram $out/bin/meli \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath ([ gpgme ] ++ lib.optional withNotmuch notmuch)
      } \
      --prefix PATH : ${lib.makeBinPath [ gnum4 ]}
  '';

  checkFlags = [
    "--skip=test_cli_subcommands" # panicking due to sandbox
  ];

  meta = {
    description = "Terminal e-mail client and e-mail client library";
    mainProgram = "meli";
    homepage = "https://meli.delivery";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      _0x4A6F
      matthiasbeyer
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
