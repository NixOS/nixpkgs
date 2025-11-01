{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "esp-generate";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${version}";
    hash = "sha256-lcxYsMeigXjwFdJQ4fJZnQL9PqVhgr7bOIsaTu2Oa88=";
  };

  cargoHash = "sha256-0p07C4OGHOkEivnokti0s9z+xXdcayUOkzTqksxUZ6o=";

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
