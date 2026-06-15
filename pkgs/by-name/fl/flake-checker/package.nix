{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-checker";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${version}";
    hash = "sha256-QE/Druzo/EDiuh7Vb+kipPgUxkIRPLsHFMSpSRMFIVw=";
  };

  cargoHash = "sha256-kKEHYKXtccXRsa1cON0oMHOWagi3mVdnf3pEgkoNn/k=";

  meta = {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
}
