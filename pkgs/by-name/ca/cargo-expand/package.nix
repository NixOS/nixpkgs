{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.85";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-2i9FAWF9b1tNdDbTwCzQY8Mh/h85uigR5IT9kzPft00=";
  };

  cargoHash = "sha256-Vl0zC9TPhiFv2SiZtzIUV7GftB1y9K1gLy1ajisP8Y0=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-expand";
  };
}
