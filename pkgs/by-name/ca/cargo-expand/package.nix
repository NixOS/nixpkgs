{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.90";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-8Ls7Wklb5cnYo6acmGtjTHV1ZhSPVEQ9BsbR78a2LG0=";
  };

  cargoHash = "sha256-8IKKK0xBgl5FiEoPrwO1uL/S+fOLv4Rof8KjquHJ6DI=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-expand";
  };
}
