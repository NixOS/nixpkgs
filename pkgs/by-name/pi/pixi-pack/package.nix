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
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "Quantco";
    repo = "pixi-pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jCKlJPLlMrMByoVU1nzqccXBeyEi9CMjrWfL+ByqDhI=";
  };

  cargoHash = "sha256-0f7IkYPQ1kIBC4aCyBU0Dpo936awol0eJNW6KcFQIAA=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkgconfig.
  env.OPENSSL_NO_VENDOR = 1;

  # Tests require downloading artifacts from conda.
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
