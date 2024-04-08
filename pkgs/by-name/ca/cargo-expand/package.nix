{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.82";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-3NukL5DyyBMR1yiSP7SWhREP/vFl+Zd2gsGxC//7edI=";
  };

  cargoHash = "sha256-niKg9IxNranrm52bXbp231cx/47kY+fd2ycdkudAWVo=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-expand";
  };
}
