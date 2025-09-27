{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "circleci-cli";
  version = "0.1.33163";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = "circleci-cli";
    rev = "v${version}";
    sha256 = "sha256-sXAssSnxoaPNXSp2SBCzJ3zbYpMNTxND5SUe0lKb2cs=";
  };

  vendorHash = "sha256-RQK51VSag1AkJMa/rmWpSuuzhRqSG2a3+sNisp0q7lU=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/CircleCI-Public/circleci-cli/version.Version=${version}"
    "-X github.com/CircleCI-Public/circleci-cli/version.Commit=${src.rev}"
    "-X github.com/CircleCI-Public/circleci-cli/version.packageManager=nix"
  ];

  postInstall = ''
    mv $out/bin/circleci-cli $out/bin/circleci

    installShellCompletion --cmd circleci \
      --bash <(HOME=$TMPDIR $out/bin/circleci completion bash --skip-update-check) \
      --zsh <(HOME=$TMPDIR $out/bin/circleci completion zsh --skip-update-check)
  '';

  meta = with lib; {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with maintainers; [ synthetica ];
    mainProgram = "circleci";
    license = licenses.mit;
    homepage = "https://circleci.com/";
  };
}
