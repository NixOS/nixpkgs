{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "loco";
  version = "0.14.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-d13BuDPXZJ2cOgaNhX95Us+T4SoJZJAyCugSySHh7U8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-g7zfPO0/8a9PPdd8CPDWRUTWdQ29tFZ3uOSux8hcExo=";

  #Skip trycmd integration tests
  checkFlags = [ "--skip=cli_tests" ];

  meta = {
    description = "Loco CLI is a powerful command-line tool designed to streamline the process of generating Loco websites";
    homepage = "https://loco.rs";
    changelog = "https://github.com/loco-rs/loco/blob/master/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sebrut ];
    mainProgram = "loco";
  };
}
