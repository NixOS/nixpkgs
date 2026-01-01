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
<<<<<<< HEAD
  version = "0.62.2";
=======
  version = "0.59.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-HNXfcZuj+yLWatwdSOP0WDkX4y9pcVwrNjsaZdD3ZNo=";
  };

  cargoHash = "sha256-wmr1dOqV8IAhqmG4SjeCra+CEpajwZJWUlTNYVVgHVo=";
=======
    hash = "sha256-aDwuMRceMxRCh9w89Q2ktpNWwmStg3KzggwhZUAAauk=";
  };

  cargoHash = "sha256-BbPX+ZKMfLtKWBnrGBRfrl6d40rBQaWJLBg0Vv5UnZE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package management made easy";
    homepage = "https://pixi.sh/";
    changelog = "https://pixi.sh/latest/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
<<<<<<< HEAD
=======
      edmundmiller
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      xiaoxiangmoe
    ];
    mainProgram = "pixi";
  };
})
