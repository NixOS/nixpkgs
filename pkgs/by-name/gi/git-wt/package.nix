{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "git-wt";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "git-wt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gZO3SAIrOQ+wEKf1VAg+e5bLVDt2/s73INZougMXH4k=";
  };

  vendorHash = "sha256-LkyH7czzBkiyAYGrKuPSeB4pNAZLmgwXgp6fmYBps6s=";

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
