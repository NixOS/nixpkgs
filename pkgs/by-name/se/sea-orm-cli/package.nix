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
  version = "1.1.11";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JaUlRQfYTg/5GC3SHjDRYHc54naOW4NpdfB6lMcQqog=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-oytYVAbmGPotnnI7morg8ePH8Ox1hD1WhGwEct4F0vw=";

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
