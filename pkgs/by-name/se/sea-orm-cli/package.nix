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
  version = "1.1.11";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-JaUlRQfYTg/5GC3SHjDRYHc54naOW4NpdfB6lMcQqog=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-oytYVAbmGPotnnI7morg8ePH8Ox1hD1WhGwEct4F0vw=";

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
