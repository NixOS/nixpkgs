{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "esp-generate";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oWWAaos1OwI72AfgadKmtg/QAVV5SI6OKsA1OKHKKbQ=";
  };

  cargoHash = "sha256-xzuwgGtWeDif3kH/x9jqw+dmF5iiJgmavKO0k5Fvyxo=";

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
