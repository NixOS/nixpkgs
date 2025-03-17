{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-stakeholder";
  version = "0.1.0-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "giacomo-b";
    repo = "rust-stakeholder";
    rev = "3717557bd297b16ce4a40bd9cea3fb6167ce338d";
    hash = "sha256-gm9VH8aegJ71MroxgtokSi4lo/eqAjtHaO42ewBJccQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-p3E4Yk7sDI6u5dv8bxRyE/Hj3kOIU54EYodX4PG23Dw=";

  meta = {
    description = "Nonsensical terminal output generator that comes in various developer flavors";
    homepage = "https://github.com/giacomo-b/rust-stakeholder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gs-101 ];
    mainProgram = "rust-stakeholder";
  };
}
