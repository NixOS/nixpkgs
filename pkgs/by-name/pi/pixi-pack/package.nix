{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pixi-pack";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "Quantco";
    repo = "pixi-pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zMrr/47oTej6uyiRpPRVlfUIFtl0wesCm+qN6Y7iUkE=";
  };

  cargoHash = "sha256-FnKmUNCmLcTTYqagOYhJFp7d/qbc0OBCb8nT7ZKx3n0=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkgconfig.
<<<<<<< HEAD
  env.OPENSSL_NO_VENDOR = 1;
=======
  OPENSSL_NO_VENDOR = 1;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Tests require downloading artifacts from conda.
  doCheck = false;

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
    description = "Pack and unpack conda environments created with pixi";
    homepage = "https://github.com/Quantco/pixi-pack";
    changelog = "https://github.com/Quantco/pixi-pack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    mainProgram = "pixi-pack";
  };
})
