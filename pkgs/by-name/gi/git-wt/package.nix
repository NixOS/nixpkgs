{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  installShellFiles,
  git,
}:

buildGo126Module (finalAttrs: {
  pname = "git-wt";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "git-wt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t4kN5Z+1zKcwK2s7So0OA+I5wKLZTjWffgtEbs/vXiQ=";
  };

  vendorHash = "sha256-O4vqouNxvA3GvrnpRO6GXDD8ysPfFCaaSJVFj2ufxwI=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/git-wt/version.Version=v${finalAttrs.version}"
  ];

  postInstall = ''
    installShellCompletion --cmd git-wt \
      --bash <($out/bin/git-wt --init bash --nocd) \
      --zsh <($out/bin/git-wt --init zsh --nocd) \
      --fish <($out/bin/git-wt --init fish --nocd)
  '';

  meta = {
    description = "Git subcommand that makes git worktree simple";
    homepage = "https://github.com/k1LoW/git-wt";
    changelog = "https://github.com/k1LoW/git-wt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "git-wt";
  };
})
