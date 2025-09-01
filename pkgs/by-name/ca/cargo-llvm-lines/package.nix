{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.44";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-llvm-lines";
    rev = version;
    hash = "sha256-keV3k+9FDULouiYCw07aaStGIt99Xa0xgexSfvehs1E=";
  };

  cargoHash = "sha256-PJ68n4ANiA6/z/oK1WrdeEWS+ttSNRYdXsBx7tXhANQ=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    mainProgram = "cargo-llvm-lines";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    changelog = "https://github.com/dtolnay/cargo-llvm-lines/releases/tag/${src.rev}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
