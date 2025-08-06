{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.43";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-llvm-lines";
    rev = version;
    hash = "sha256-fYoVPm3RxR1LZ8wJQpXQG3g69Fh7LLFwXZXmj+kr8zc=";
  };

  cargoHash = "sha256-yhZ2MKswFvzkMamI9np7CRsQO4D/sldumaLPzSNsHgA=";

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
