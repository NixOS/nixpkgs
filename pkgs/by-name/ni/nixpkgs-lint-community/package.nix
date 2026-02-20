{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-lint";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixpkgs-lint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o1VWM46lEJ9m49s/ekZWf8DkCeeWm4J3PQtt8tVXHbg=";
  };

  cargoHash = "sha256-wK2ZMqxgSLGhM7TsztFkZHB2+WnT+8Tjd3UrFdIvGpI=";

  meta = {
    description = "Fast semantic linter for Nix using tree-sitter";
    mainProgram = "nixpkgs-lint";
    homepage = "https://github.com/nix-community/nixpkgs-lint";
    changelog = "https://github.com/nix-community/nixpkgs-lint/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      artturin
    ];
  };
})
