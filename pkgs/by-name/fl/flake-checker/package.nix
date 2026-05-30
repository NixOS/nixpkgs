{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flake-checker";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0ftHzqFpFkKZKByWJ49/YySrXBU4lCxvcpbTuMY8ZXs=";
  };

  cargoHash = "sha256-5zzSLk5QT3X6rdGEPHPelXFd5nOxNtlbqDHwV7fFDKY=";

  meta = {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
})
