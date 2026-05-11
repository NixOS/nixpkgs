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
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "Quantco";
    repo = "pixi-pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j9b+wpVUvEU/0R3inMO12TUs65Avtn3NU11gEE4hxLM=";
  };

  cargoHash = "sha256-22fE8XFTt10mUGl1jYb8UgoxD/rBlX4dNkjKEgtgAR8=";

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
