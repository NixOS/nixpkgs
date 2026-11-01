{
  lib,
  fetchFromGitHub,
  gitMinimal,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "esp-generate";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PG6IryXm2ntp7A5lm9IOWtlH9uLvavHg9LBLvP57iGQ=";
  };

  cargoHash = "sha256-v+IP/XChhgFNyFlt1IeIICKIvOpQBi/xId7qkPnPlcQ=";

  nativeCheckInputs = [ gitMinimal ];

  meta = {
    description = "Template generation tool to create no_std applications targeting Espressif's chips";
    homepage = "https://github.com/esp-rs/esp-generate";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.eymeric ];
  };
})
