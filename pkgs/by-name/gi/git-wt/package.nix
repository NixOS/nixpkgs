{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
}:

buildGoModule rec {
  pname = "git-wt";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "git-wt";
    rev = "v${version}";
    hash = "sha256-poAKWBKvTOCIuBrDMm9S1TaYqsK5HweybTNO+p0FBfk=";
  };

  vendorHash = "sha256-K5geAvG+mvnKeixOyZt0C1T5ojSBFmx2K/Msol0HsSg=";

  nativeCheckInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/git-wt/version.Version=v${version}"
  ];

  meta = {
    description = "Git subcommand that makes git worktree simple";
    homepage = "https://github.com/k1LoW/git-wt";
    changelog = "https://github.com/k1LoW/git-wt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "git-wt";
  };
}
