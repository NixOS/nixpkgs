{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rdme";
  version = "1.4.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IB+n9abFeWLgJLdo3NjffcGrIxXhNdZ2moyfIG+gMoc=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  cargoHash = "sha256-mD95+Q6xaL0LFk5841LBrQqzFU7KFJbUgHB96zXy2KU=";

  meta = with lib; {
    description = "Cargo command to create the README.md from your crate's documentation";
    mainProgram = "cargo-rdme";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${version}/release-notes.md";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ GoldsteinE ];
  };
}
