{
  lib,
  buildGo123Module,
  fetchFromGitLab,
  installShellFiles,
  stdenv,
  nix-update-script,
}:

buildGo123Module rec {
  pname = "glab";
  version = "1.51.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-EWcoEm6DbRT0PP2qYhdwDHCkbeAG6vDVATPhX9pPfiw=";
  };

  vendorHash = "sha256-f6qAFeB9kshtQ2AW6OnEGSnhJYlJ2gAGRDplVmQSVNA=";

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

  passthru.updateScript = nix-update-script { };

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
