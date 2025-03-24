{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rune-languageserver";
  version = "0.13.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Kw6Qh/9eQPMj4V689+7AxuJB+aCciK3FZTfcdhyZXGY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YviRACndc4r4ul72ZF3I/R/nEsIoML2Ek2xqUUE3FDQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    RUNE_VERSION = version;
  };

  meta = with lib; {
    description = "Language server for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://crates.io/crates/rune-languageserver";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rune-languageserver";
  };
}
