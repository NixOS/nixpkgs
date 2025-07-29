{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "1.1.12";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-549ZThGMQ601q0nrzAD20MIrErANcghtB+DxYPUBUt4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-pwOsuet1qV7175pso5tZm1VY4JznCx63XNcBX0Jh4F4=";

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
    description = "Command line utility for SeaORM";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ traxys ];
  };
}
