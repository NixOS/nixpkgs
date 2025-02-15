{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "esp-generate";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${version}";
    hash = "sha256-qDlEI9cav2RSsYinIlW4VqmCtUW+vAgFJOE2miFAVVo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fBTJBHlbIvj1JYJBrtZdaIU1ztB3yE3LF6GxTfGXWTM=";

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
