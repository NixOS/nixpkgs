{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  makeBinaryWrapper,
  libgit2,
  openssl,
  aws-lc,
  zstd,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pixi";
  version = "0.84.2";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zJc+4iuU3TeOkFoAUWlB3y+KpTz7zwQvNRQd0y1iXvc=";
  };

  cargoHash = "sha256-zD0Rwa5mimOgOIQ8EyJRP11y3sFoA/s7Z5fZr3zTurE=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = [
    libgit2
    openssl
    aws-lc
    zstd
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

  postFixup = ''
    wrapProgram $out/bin/pixi --set-default PIXI_TLS_ROOT_CERTS system
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package management made easy";
    homepage = "https://pixi.sh/";
    changelog = "https://pixi.sh/latest/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      esteve
      xiaoxiangmoe
    ];
    mainProgram = "pixi";
  };
})
