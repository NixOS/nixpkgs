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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Quantco";
    repo = "pixi-pack";
    tag = "v${version}";
    hash = "sha256-gzP/01pck14cMN0PopoCO27dxncWz4yIZFAzXU+4IQ0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dTpwlE/o7YzLWfJSEOgHfI64l9XNLt3gC1GE4IhL66o=";

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
