{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rustPlatform,
  testers,
  komac,
  dbus,
  zstd,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  bzip2,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "komac";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "russellbanks";
    repo = "Komac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wOojfEEzf/NGiyL3Q8ql7t7/gM/hVfgeQmc5cvugKR4=";
  };

  cargoHash = "sha256-Bn2Nq/aH2Ta/3VaNQwLClv9gaz2qjo0Ko+d1XQtVdFY=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  buildInputs = [
    dbus
    openssl
    zstd
    bzip2
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    YRX_REGENERATE_MODULES_RS = "no";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/komac";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd komac \
      --bash <($out/bin/komac complete bash) \
      --zsh <($out/bin/komac complete zsh) \
      --fish <($out/bin/komac complete fish)
  '';

  passthru = {
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;

      package = komac;
      command = "komac --version";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Community Manifest Creator for WinGet";
    homepage = "https://github.com/russellbanks/Komac";
    changelog = "https://github.com/russellbanks/Komac/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      HeitorAugustoLN
    ];
    mainProgram = "komac";
  };
})
