{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "esp-generate";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${version}";
    hash = "sha256-o8b30xCkHWdfGhI+8KXVj1U8xJtt7YsRcKBL6FxUVW8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eTXSVeFzlQHBPWPRgt//uvtsPal4KeD2Rk7Sevkx/LE=";

  meta = {
    description = "Template generation tool to create no_std applications targeting Espressif's chips";
    homepage = "https://github.com/esp-rs/esp-generate";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.eymeric ];
  };
}
