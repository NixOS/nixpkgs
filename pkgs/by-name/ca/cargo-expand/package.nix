{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.102";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    rev = version;
    hash = "sha256-lqTbBPoXnKk5JQqFYxdSGGWgy9vyKeUCpdYUZI4veHY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-J55gjVsxaFf8fGCIjX60Pwb49WTN/eWqbobQxY5kVuM=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-expand";
  };
}
