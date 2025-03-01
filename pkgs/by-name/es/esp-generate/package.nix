{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "esp-generate";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${version}";
    hash = "sha256-Z+PsGx3Y2WZLO5QK5icI89YPOmY4p/RBMiYecEOfmwc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uvHZyvIcPLB1GW7EkJshAeGRI3xJZtN9kPrLhHGoojs=";

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
