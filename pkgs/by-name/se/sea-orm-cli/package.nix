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
  version = "1.1.8";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-XPankeAVuG5zADxM/4ZZgV2GBhIA+XzkhN+MLvFZpiU=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-sxCfi8zcD48WCvcv8sJ2ocPyKOuxoINU5dDh7ons+nw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    mainProgram = "sea-orm-cli";
    homepage = "https://www.sea-ql.org/SeaORM";
    changelog = "https://github.com/SeaQL/sea-orm/releases/tag/${finalAttrs.version}";
    description = "Command line utility for SeaORM";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      traxys
      xiaoxiangmoe
    ];
  };
})
