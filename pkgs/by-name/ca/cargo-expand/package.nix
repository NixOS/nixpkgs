{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.86";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-wp4JYuAHtZrHer4db0vBCchf8mQIt6jXWqjqpGKws4o=";
  };

  cargoHash = "sha256-QNH3G34yTEecZyVgw2a1RJnd1CMfV4aw1OJqes/cK2s=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-expand";
  };
}
