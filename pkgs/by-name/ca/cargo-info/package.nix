{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-info";
  version = "0.7.7";

  src = fetchFromGitLab {
    owner = "imp";
    repo = "cargo-info";
    rev = version;
    hash = "sha256-MrkYGUd1jsAqIVYWe7YDZaq7NPv/mHQqLS7GFrYYIo8=";
  };

  cargoHash = "sha256-C8BIgJeUPvFzf0LTBMZ3oyE0eWh5HH6aobhUAHBxxKU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Cargo subcommand to show crates info from crates.io";
    mainProgram = "cargo-info";
    homepage = "https://gitlab.com/imp/cargo-info";
    changelog = "https://gitlab.com/imp/cargo-info/-/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
