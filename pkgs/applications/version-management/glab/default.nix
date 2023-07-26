{ lib, buildGoModule, fetchFromGitLab, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "glab";
  version = "1.31.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-K7yGRuIfYEqs4ziystxLMK+dYUZoyGlBJAmx2qmY08Q=";
  };

  vendorHash = "sha256-WfzN70HHLatBuV+GW2VC+5laR3rBfDOqPydyxMSmL3s=";

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
    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)
  '';

  meta = with lib; {
    description = "GitLab CLI tool bringing GitLab to your command line";
    license = licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    maintainers = with maintainers; [ freezeboy ];
  };
}
