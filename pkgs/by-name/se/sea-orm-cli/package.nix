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
  version = "2.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-zapXno3UPgUMsohUxXpldBPScyqYhesR6/9dTXbFsUA=";
  };

  cargoHash = "sha256-sSXa4hOzhnQD1rFvqsGrev7v0P9MUgEoIo0bRoZx7tM=";

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
