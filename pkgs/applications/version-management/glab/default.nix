{ lib, buildGoModule, fetchFromGitLab, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "glab";
  version = "1.33.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-sBovwqL+3UmOdGf5pnAVzAiAbu69PJi7YhfcJqdejTY=";
  };

  vendorHash = "sha256-HiU6Kx/du8QLNKUDsSMm349msxSxyNRppxadtIpglBg=";

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

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
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
  };
}
