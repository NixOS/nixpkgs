{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  bash,
  nix-update-script,
}:
let
  version = "0.1.1";
in
rustPlatform.buildRustPackage {
  pname = "git-prole";
  inherit version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "git-prole";
    rev = "refs/tags/v${version}";
    hash = "sha256-IJsNZt5eID1ghz5Rj53OfidgPoMS2qq+7qgqYEu4zPc=";
  };

  cargoHash = "sha256-2z7UEHVomm2zuImdcQq0G9fEhKrHLrPNUhVrFugG3w4=";

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
