{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "circleci-cli";
  version = "0.1.34038";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = "circleci-cli";
    rev = "v${version}";
    sha256 = "sha256-kEhAiTcWY+xXX5jFgJZtle0CEwqRT2BHDEM8iSUFRh4=";
  };

  vendorHash = "sha256-QMSciB81khHhjd/4Km1YYyTiEFDF75AcNGsmZTLLO5Q=";

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

  meta = {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with lib.maintainers; [ synthetica ];
    mainProgram = "circleci";
    license = lib.licenses.mit;
    homepage = "https://circleci.com/";
  };
}
