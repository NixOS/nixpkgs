{
  stdenv,
  lib,
  fetchzip,
  rustPlatform,

  # native build inputs
  capnproto,
  pkg-config,
  installShellFiles,
  makeWrapper,
  mandoc,
  buildPackages,
  file,
  writableTmpDirAsHomeHook,

  # build inputs
  openssl,
  dbus,
  sqlite,
  nettle,

  # runtime deps
  gpgme,

  withNotmuch ? true,
  notmuch,
}:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "0.9.0";

  src = fetchzip {
    urls = [
      "https://git.meli-email.org/meli/meli/archive/v${version}.tar.gz"
      "https://codeberg.org/meli/meli/archive/v${version}.tar.gz"
      "https://github.com/meli/meli/archive/refs/tags/v${version}.tar.gz"
    ];
    hash = "sha256-e8KY0t54wWcC2MlWJQkutx1roGj3trgdUSgo/im2TtQ=";
  };

  cargoHash = "sha256-qBthm+tFSlzASzCZHlIM8SA9h3wIcWIcL1hif2aHufo=";

  # Needed to get openssl-sys to use pkg-config
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    capnproto
    pkg-config
    installShellFiles
    makeWrapper
    mandoc
    rustPlatform.bindgenHook
    (buildPackages.rustfmt.override { asNightly = true; })
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
    nettle
  ];

  nativeCheckInputs = [
    file
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    installManPage meli/docs/*.{1,5,7}

    wrapProgram $out/bin/meli \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ gpgme ] ++ lib.optional withNotmuch notmuch)}

    installShellCompletion --cmd meli \
      --bash <($out/bin/meli completions bash) \
      --fish <($out/bin/meli completions fish) \
      --zsh <($out/bin/meli completions zsh)
  '';

  checkFlags = [
    "--skip=test_cli_subcommands" # panicking due to sandbox
  ];

  meta = {
    description = "Terminal e-mail client and e-mail client library";
    mainProgram = "meli";
    homepage = "https://meli-email.org/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      _0x4A6F
      matthiasbeyer
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
