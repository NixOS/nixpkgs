{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-checker";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${version}";
    hash = "sha256-zbNODGugDSFsTKc7V9r6X4+mNTAbjq/uD+ESprqzPgg=";
  };

  cargoHash = "sha256-zfnaav/ndcwado7P93Qxh0xPWIaBFiAV0FIZ8jvnt/E=";

  meta = with lib; {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
}
