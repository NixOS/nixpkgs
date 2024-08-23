{ lib, rustPlatform, fetchCrate, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rdme";
  version = "1.4.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-AARkXr6qOq9u/nmcmCnA4P+Q+MPPChCXoRaYiLwCNPs=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  cargoHash = "sha256-myTh+zOtAt9h/irld7OHSXKMv0V+LAR4h/afYKvXeXg=";

  meta = with lib; {
    description = "Cargo command to create the README.md from your crate's documentation";
    mainProgram = "cargo-rdme";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${version}/release-notes.md";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ GoldsteinE ];
  };
}
