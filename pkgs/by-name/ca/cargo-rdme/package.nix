{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rdme";
  version = "1.4.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lVu9w8l3+SeqiMoQ8Bjoslf7tWz49jrrE4g/pDU1axI=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  cargoHash = "sha256-UqPvvqX+QHFiRil2XadiHyO1EMA51IAUGk6cNH3um54=";

  meta = with lib; {
    description = "Cargo command to create the README.md from your crate's documentation";
    mainProgram = "cargo-rdme";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${version}/release-notes.md";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ GoldsteinE ];
  };
}
