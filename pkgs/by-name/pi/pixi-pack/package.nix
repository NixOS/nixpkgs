{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "pixi-pack";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Quantco";
    repo = "pixi-pack";
    tag = "v${version}";
    hash = "sha256-fTQSSrmfWvyGD1+YM2I6Lly6gYwMlB/h8VRbDsvG3mU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ujrEUXQGaESNSZndBblM/4e/zl376FRdj4Hp3AA2yJA=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  # Tests require downloading artifacts from conda.
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pack and unpack conda environments created with pixi";
    homepage = "https://github.com/Quantco/pixi-pack";
    changelog = "https://github.com/Quantco/pixi-pack/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    mainProgram = "pixi-pack";
  };
}
