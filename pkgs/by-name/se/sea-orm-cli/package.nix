{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sea-orm-cli";
  version = "2.0.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-tkyZSsTE1a08AIif5NNkBazASs+pvBgP69CnZhEZkhw=";
  };

  cargoHash = "sha256-4+rFHOBRyUGF6DXxT4Y54Y2s4F9MGcNF/ELWj/4fPWo=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    mainProgram = "sea-orm-cli";
    homepage = "https://www.sea-ql.org/SeaORM";
    description = "Command line utility for SeaORM";
    changelog = "https://github.com/SeaQL/sea-orm/releases/tag/sea-orm-cli%40${finalAttrs.version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      traxys
      anish
    ];
  };
})
