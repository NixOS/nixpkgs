{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rune";
  version = "0.13.4";

  src = fetchCrate {
    pname = "rune-cli";
    inherit version;
    hash = "sha256-+2eXTkn9yOMhvS8cFwAorLBNIPvIRwsPOsGCl3gtRSE=";
  };

  cargoHash = "sha256-SgfgoMqr2Cc7+qhf9Ejl4Ect1JR9RqI9I0b+PrdvdOs=";

  env = {
    RUNE_VERSION = version;
  };

  meta = {
    description = "Interpreter for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://rune-rs.github.io/";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "rune";
  };
}
