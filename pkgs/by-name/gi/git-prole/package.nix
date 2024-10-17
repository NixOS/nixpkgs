{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  bash,
  nix-update-script,
}:
let
  version = "0.5.1";
in
rustPlatform.buildRustPackage {
  pname = "git-prole";
  inherit version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "git-prole";
    rev = "refs/tags/v${version}";
    hash = "sha256-jJEskahZRCpM2WEH4myTLfowQxEJ4WCNXbTwGkwBHnY=";
  };

  cargoHash = "sha256-u4UJH+dIDI+I6fEQTRe3RRufYZwxBENxnwULSSCOZF8=";

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
