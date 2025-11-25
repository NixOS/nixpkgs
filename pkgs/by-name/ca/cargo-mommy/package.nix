{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mommy";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-2WR6xUYL/bLgZlI4ADbPAtdLq0y4MoVP8Loxdu/58Wc=";
  };

  cargoHash = "sha256-B0hPxw/8T5x6E0dwPIHoPChLx4K2ORvPEUDYHncZrPE=";

  meta = with lib; {
    description = "Cargo wrapper that encourages you after running commands";
    mainProgram = "cargo-mommy";
    homepage = "https://github.com/Gankra/cargo-mommy";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ GoldsteinE ];
  };
}
