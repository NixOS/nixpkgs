{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flake-checker";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MUbF2mOrcoODe26j0OaXHLk73yFhB+0/d2yPaeBEi6M=";
  };

  cargoHash = "sha256-toC9qMq06Grh6NJZZUb7cbQdNeI7lwqDqbJO85a3zwk=";

  meta = {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
})
