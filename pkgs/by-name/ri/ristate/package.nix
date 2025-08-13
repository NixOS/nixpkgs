{
  lib,
  rustPlatform,
  fetchFromGitLab,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "ristate";
  version = "0-unstable-2023-07-23";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "ristate";
    rev = "92e989f26cadac69af1208163733e73b4cf447da";
    hash = "sha256-6slH7R6kbSXQBd7q38oBEbngaCbFv0Tyq34VB1PAfhM=";
  };

  cargoHash = "sha256-6uvIc69x/yHkAC3GJUuYGcCbpVyX/mb/pXLf+BQC+48=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "River-status client written in Rust";
    homepage = "https://gitlab.com/snakedye/ristate";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "ristate";
  };
}
