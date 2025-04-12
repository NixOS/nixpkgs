{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  bash,
  nix-update-script,
}:
let
  version = "0.5.3";
in
rustPlatform.buildRustPackage {
  pname = "git-prole";
  inherit version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "git-prole";
    rev = "refs/tags/v${version}";
    hash = "sha256-QwLkByC8gdAnt6geZS285ErdH8nfV3vsWjMF4hTzq9Y=";
  };

  cargoHash = "sha256-K4gIvK0qxMJh9SXF9JZFacDKv6TwvDQe8JVX2rtq/hU=";

  nativeCheckInputs = [
    git
    bash
  ];

  meta = {
    homepage = "https://github.com/9999years/git-prole";
    changelog = "https://github.com/9999years/git-prole/releases/tag/v${version}";
    description = "`git-worktree(1)` manager";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "git-prole";
  };

  passthru.updateScript = nix-update-script { };
}
