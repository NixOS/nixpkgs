{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
    hash = "sha256-hTlgIPXXdhxFtK/acXITwitIg1DGgF4cCVaAxogWPrk=";
  };

  cargoHash = "sha256-6F4CX9uiCfPbgFRZ0hC/s5xT42S2V5ZgGQ+O2bHb9vg=";

  meta = with lib; {
    description = "Cargo plugin to easily build Swift packages from Rust code";
    mainProgram = "cargo-swift";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ elliot ];
  };
}
