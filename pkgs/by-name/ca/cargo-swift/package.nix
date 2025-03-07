{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
    hash = "sha256-2jKu1Hl+2HnlZWu+mLmrhrhzH1Q/S9ej+SJyjeMr4CI=";
  };

  cargoHash = "sha256-PQkV2Gz1whIM772bGAEC0TQO9w4DaWSrtCejgVCFTpA=";

  meta = with lib; {
    description = "Cargo plugin to easily build Swift packages from Rust code";
    mainProgram = "cargo-swift";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ elliot ];
  };
}
