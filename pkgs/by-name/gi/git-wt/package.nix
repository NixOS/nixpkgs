{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "git-wt";
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "git-wt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K6ygsdLXEHCFmtagZpvHlbW4Iedc2HG/PS61U08IY6s=";
  };

  vendorHash = "sha256-FuUkvFmW1mJo3OO7wmZzO0LMx5McqfYk1K0jkVRuceQ=";

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
