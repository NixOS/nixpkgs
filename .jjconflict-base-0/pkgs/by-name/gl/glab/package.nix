{
  lib,
  buildGo123Module,
  fetchFromGitLab,
  installShellFiles,
  stdenv,
}:

buildGo123Module rec {
  pname = "glab";
  version = "1.49.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-G9z9lISalj3ZXlvDY+qA+0NB6F7flBd1cTcGfxrM91U=";
  };

  vendorHash = "sha256-SsWZO77KqDPzyEK57WaK4NpnDWUtZPP0qur2EvEoiL0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    # failed to read configuration:  mkdir /homeless-shelter: permission denied
    export HOME=$TMPDIR
  '';

  subPackages = [ "cmd/glab" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    make manpage
    installManPage share/man/man1/*
    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)
  '';

  meta = {
    description = "GitLab CLI tool bringing GitLab to your command line";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    changelog = "https://gitlab.com/gitlab-org/cli/-/releases/v${version}";
    maintainers = with lib.maintainers; [
      freezeboy
      luftmensch-luftmensch
    ];
    mainProgram = "glab";
  };
}
