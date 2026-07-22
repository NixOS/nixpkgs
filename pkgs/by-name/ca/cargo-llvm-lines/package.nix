{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-llvm-lines";
  version = "0.4.46";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-llvm-lines";
    tag = finalAttrs.version;
    hash = "sha256-Pyl3IGPMjw48mjOh/P4FffP7r+Yd0bJodyKSSGK/kCQ=";
  };

  cargoHash = "sha256-/8Ch74qXamQIgi1uR5huK+EnqpvGfIpYaVygu7NgihI=";

  meta = {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    mainProgram = "cargo-llvm-lines";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    changelog = "https://github.com/dtolnay/cargo-llvm-lines/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
