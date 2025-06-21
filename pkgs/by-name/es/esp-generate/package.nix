{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "esp-generate";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${version}";
    hash = "sha256-4RF0XcDpUcMQ0u2FTRBnZdQDM7DlaI7pl5HukMbbbBE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-c/BYf6SXOdI/K4t3fT4ycuILkIYCiSbHafLprSMvK8E=";

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
