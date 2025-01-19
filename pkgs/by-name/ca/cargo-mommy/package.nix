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

  cargoHash = "sha256-iQt6eTCcpzhFnrDkUmT4x7JX+Z7fWdW5ovbB/9Ui7Sw=";

  meta = {
    description = "Cargo wrapper that encourages you after running commands";
    mainProgram = "cargo-mommy";
    homepage = "https://github.com/Gankra/cargo-mommy";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ GoldsteinE ];
  };
}
