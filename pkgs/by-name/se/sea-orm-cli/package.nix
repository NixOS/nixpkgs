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
  version = "1.1.13";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RXHWMgq0dom0WzMyK5J8E8UT0YynHoqWIprtI0tksmM=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-HWLV4cBaEZVuLH/w7AEWHwpkX006YgP+1w6U0EVQZfg=";

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
