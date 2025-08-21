{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  libgit2,
  openssl,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pixi";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmFoIoyTYq/xqPNBuy90aK/Ao1DGx+3Jb1zzatNY7+Q=";
  };

  cargoHash = "sha256-FWjZiBMSUFBIi+Sx5FTp2UZa12b+pmtx1eqVETHQWEQ=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libgit2
    openssl
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OPENSSL_NO_VENDOR = 1;
  };

  # As the version is updated, the number of failed tests continues to grow.
  doCheck = false;

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd pixi \
        --bash <(${emulator} $out/bin/pixi completion --shell bash) \
        --fish <(${emulator} $out/bin/pixi completion --shell fish) \
        --zsh <(${emulator} $out/bin/pixi completion --shell zsh)
    ''
  );

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package management made easy";
    homepage = "https://pixi.sh/";
    changelog = "https://pixi.sh/latest/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      edmundmiller
      xiaoxiangmoe
    ];
    mainProgram = "pixi";
  };
})
