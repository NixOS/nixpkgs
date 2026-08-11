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
  version = "2.0.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-TpHNjY8r9a8d6senzeQLJl/n0hytytx+NV+atjyti1k=";
  };

  cargoHash = "sha256-eE777DE1g87NobNPHdMhqCFc8RZtQyL/QM29iFJV8p4=";

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
