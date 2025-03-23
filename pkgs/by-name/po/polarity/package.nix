{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-03-14";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "ab9fda44fb490da445dcaee7ad9f8bf08b9e9e10";
    hash = "sha256-ufWHDqvAaQiqwlezm95BCTLMdQEK5NTmMQgeq3oKR1o=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tower-lsp-server-0.21.0" = "sha256-aeCc8m7zf3Kww1EBmMJFhQTYJ9lP6+R+9WzQ8yaj3Jo=";
    };
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}
