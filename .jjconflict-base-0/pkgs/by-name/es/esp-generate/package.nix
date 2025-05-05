{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "esp-generate";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${version}";
    hash = "sha256-yk7iv5nq2b/1OY77818I7mXW96YxjwwJS3iiv1KXVHs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ncTX9cDSAf6ZGlz0utGYxkuXcx85vt3VHQzdmQhCNf0=";

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
