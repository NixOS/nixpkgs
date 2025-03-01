{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rune";
  version = "0.13.4";

  src = fetchCrate {
    pname = "rune-cli";
    inherit version;
    hash = "sha256-+2eXTkn9yOMhvS8cFwAorLBNIPvIRwsPOsGCl3gtRSE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SgfgoMqr2Cc7+qhf9Ejl4Ect1JR9RqI9I0b+PrdvdOs=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    RUNE_VERSION = version;
  };

  meta = with lib; {
    description = "Interpreter for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://rune-rs.github.io/";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rune";
  };
}
