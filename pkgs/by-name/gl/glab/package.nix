{ lib, buildGo123Module, fetchFromGitLab, installShellFiles, stdenv }:

buildGo123Module rec {
  pname = "glab";
  version = "1.47.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-mAM11nQ6YJJWNFOR9xQbgma7Plvo4MdcW2Syniw7o60=";
  };

  vendorHash = "sha256-uwSVdebZtIpSol553gJC0ItkEqa6qXXOAVFvzjsHSSI=";

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

  meta = with lib; {
    description = "GitLab CLI tool bringing GitLab to your command line";
    license = licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    changelog = "https://gitlab.com/gitlab-org/cli/-/releases/v${version}";
    maintainers = with maintainers; [ freezeboy ];
    mainProgram = "glab";
  };
}
