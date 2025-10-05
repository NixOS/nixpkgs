{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.45";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-llvm-lines";
    rev = version;
    hash = "sha256-5Tf3vkDTCQCmYvfKW3OHCese6HEs9CNbcUeLyS7MsOE=";
  };

  cargoHash = "sha256-JrH7W2zRDoPa1ENQCfE++2y2VEC3INg/cst5ob2hmy0=";

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
