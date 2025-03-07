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
  version = "1.1.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-6SFEzbXarfF8FXQqzc8n5S283xKfqqS/sfIBzpGxS04=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-/44i91g0BllvhqZAqvm4cpm4JTWtm1wuydis33pjY+U=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
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
