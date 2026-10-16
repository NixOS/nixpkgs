{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "git-wt";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "git-wt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lw+oqKOBFE0vqP34N0Pf59Gy7ZmlaNMDikcMdJ7zVTM=";
  };

  vendorHash = "sha256-SwhoLrOLxR+Q5iaA37N7zGSriYoxnr0AKlz091ZCj9k=";

  nativeCheckInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/git-wt/version.Version=v${finalAttrs.version}"
  ];

  meta = {
    description = "Git subcommand that makes git worktree simple";
    homepage = "https://github.com/k1LoW/git-wt";
    changelog = "https://github.com/k1LoW/git-wt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "git-wt";
  };
})
